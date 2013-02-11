// base class for displayed nodes; loosely corresponds to nodes in data tree parsed from json

class rexNode {
  Object value;      // why we're all here
  RowStack contents; // for arranging
  String hint = "?";
  
  protected Sz min, max;         // stretchiness
  protected Modes arrangement;   // layout state
  protected Visibility vis;      // expand/collapse state
  protected String primary = ""; // summary field
  protected boolean editable = false;
  
  private ArrayList<rexNode> children = new ArrayList<rexNode>();  // contained nodes

  rexNode (Sz max) { init(max); }
  rexNode () { init(new Sz()); }
  rexNode (Object o) { init(new Sz()); value = o; }
  private void init(Sz maxp) { 
    min = new Sz();   max = maxp;
    vis = new Visibility(Visibility.EXPANDED);
    arrangement = new Modes(Modes.PACK);
    contents = new RowStack(min);
  }
  
  void addChild(rexNode node) {
      children.add(node);
  }
  
  void drawasroot(Pt origin, int gray) {
    clickRoot = new ClickNet(new Rect(origin, max), this);
    arrange(max.w);                // one pass to organize everything
    draw(origin, gray, clickRoot); // second pass to put on screen
  }
  
  protected void draw(Pt origin, int gray) {
    if (this == selected && editMode)
      fill(255);
    else
      fill(gray);
    stroke(gray);   
    rect((new Rect(new Pt(margin), contents.bounds.size()))
                  .move(origin));
  }
  
  protected void clickReceived(Pt p)
  {
    if (selected == this) {
      editMode = true;
    } else {
      finishEditing(true);
      if (editable)
        selected = this;
    } 
    if (this == root) 
      loadJson(randomFile()); 
  }
  
  protected boolean keyReceived(int key) {
    return false; // key was not handled
  }
  
  protected void finishEditing(boolean save) { 
    if(save && selected != null) 
      selected.saveChanges();
    selected = null;
    editMode = false;
    editString = null;
  }
 
  protected void saveChanges() { println("saving nuthin'"); }
  
  protected ArrayList<String> getSummaries() { println("don't get here."); return new ArrayList<String>(); }

  private boolean arrange(int parent_maxw) {
    ArrayList<rexNode> use_children = children;

    // handle visibility options: expanded, collapsed, partial
    if (vis.v == Visibility.COLLAPSED) {
        contents.bounds = reduce(contents.bounds); // shrink in a visually-pleasing manner
        if(contents.bounds.w == 0 && contents.bounds.h == 0)
          return false;                              // don't pack the kids
        return true;
    } else if (vis.v == Visibility.PARTIAL) {
        use_children = new ArrayList<rexNode>();
        for (String s: getSummaries()) {
          use_children.add(new rexNodeString(s));
        }
    }

    // constrain size if specified by parent
    int use_maxw = (parent_maxw == -1) ? max.w : max(max.w, parent_maxw);
    contents = new RowStack(min);
    Row row = new Row(contents.nextRowLoc());

    // start fillin' rows
    for (rexNode node: use_children){
      if(!node.arrange(use_maxw))
        continue;

      // handle layout modes: row, column, best-packing
      switch (arrangement.m) {
        case Modes.PACK:
           // make a new row any time the current one is full
           if (    use_maxw != -1
                && row.count > 0
                && row.bounds.w + node.contents.bounds.w + 2 * margin > use_maxw ) {
            contents.add(row);
            row = new Row(contents.nextRowLoc());
          }
          break;
        case Modes.COLUMN:
          // make a new row after every entry);
          if ( row.count > 0 ) {
            contents.add(row);
            row = new Row(contents.nextRowLoc());
          }
          break;
      }
      row.add(node);
    }
    if (row.elements.size() > 0) { contents.add(row); }
    return true;
  }
  
  private void draw(Pt origin, int gray, ClickNet net) {
    if (vis.v == Visibility.COLLAPSED) { return; }
    
    this.draw(origin, gray);       // draw self
    for (Row row: contents.rows) { // draw children
      int xoffset = 0;
      for (rexNode node: row.elements) {
        Rect nodeBox = new Rect(row.bounds.origin(), node.contents.bounds.size())
                               .move(origin)
                               .move(new Pt(xoffset, 0))
                               .move(new Pt(margin));
        ClickNet subNet = new ClickNet(nodeBox, node);
        net.add(subNet);
        node.draw(nodeBox.origin(), gray + 20, subNet); // recurse
        xoffset += node.contents.bounds.w + margin;
      }
    }
  }
}

