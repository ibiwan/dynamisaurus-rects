//this sucks.  is there a better enum?

class Visibility {
  final static int EXPANDED  = 1;
  final static int COLLAPSED = 2;
  final static int PARTIAL   = 3;
  int v;
  Visibility(int v_) { v = v_; }
}

class Modes {
  final static int PACK   = 1;
  final static int COLUMN = 2;
  final static int ROW    = 3;
  int m;
  Modes(int m_) { m = m_; }
}

class rexNode {
  Visibility vis = new Visibility(Visibility.EXPANDED);
  Object value;
  rexKey keyBox; // for labeling
  RowStack rows; // for arranging
  protected Sz min, max;
  protected rexNode parent;
  protected Modes arrangement = new Modes(Modes.PACK);
  protected String primary = "";
  private ArrayList<rexNode> children = new ArrayList<rexNode>();

  rexNode (Sz min, Sz max) { init(min, max); }
  rexNode (rexNode parent) { 
    init(new Sz(-1, -1), new Sz(-1, -1)); 
    if (parent != null) { parent.addChild(this); }
  }
  private void init(Sz minp, Sz maxp) { min = minp; max = maxp; }
  
  void addChild(rexNode node) {
    try {
      node.parent = this;
      children.add(node);
    }
    catch (Exception e) {
      println("Exception adding child to node");
      e.printStackTrace();
    }
  }
  
  void drawasroot(int x, int y, int gray) {
    clickRoot = new ClickNet(new Rect(x, y, max.w, max.h), this);
    arrangeChildren(max.w); // not called from draw directly as it needs to be done only once
    draw(x, y, gray, clickRoot);
  }
  
  protected void draw(int x, int y, int gray) {
    stroke(gray);
    fill(gray);
    rect(x + margin, y + margin, rows.box.w, rows.box.h);
  }
  
  protected void clickReceived(Pt p) { } // implement where appropriate in child classes
  
  private void arrangeChildren(int parent_maxw) {
    ArrayList<rexNode> use_children = children;

    switch(vis.v) {
      case Visibility.EXPANDED:    // show everything
        break;                         // handle below
      case Visibility.COLLAPSED:   // show nothing
        rows.box = reduce(rows.box);   // shrink in a visually-pleasing manner
        return;                        // don't pack the kids
      case Visibility.PARTIAL:     // show minimal
        use_children = new ArrayList<rexNode>();
        int i = 0;
        ArrayList<String> summaries = new ArrayList<String>();
        for (rexNode n: children) {    // use labels instead of full objects
          String use_str = "" + i++;
          for (rexNode c: n.children) {
            if (c.keyBox != null && ((String)(c.keyBox.value)).equals(primary)) {
              use_str = (String)(c.children.get(1).value);
              break;
            }
          }
          summaries.add(use_str);
        }
        for (String s: summaries) {
          use_children.add(new rexNodeString(null, s));
        }
        break;
    }

    int use_maxw = (parent_maxw == -1) ? max.w : max(max.w, parent_maxw);
    rows = new RowStack(min);
    Row row = new Row(new Pt(0, 0));

    for (rexNode node: use_children){
      node.arrangeChildren(use_maxw); // recurse here!
      switch (arrangement.m) {
        case Modes.PACK:     // make a new row any time the current one is full
           if (    use_maxw != -1
                && row.elements.size() > 0
                && row.box.w + node.rows.box.w + 2 * margin > use_maxw ) {
            row = new Row(rows.add(row));
          }
          break;
        case Modes.COLUMN:  // make a new row after every entry
          if ( row.elements.size() > 0 ) {
            row = new Row(rows.add(row));
          }
          break;
        case Modes.ROW:     // never make a new row
          break;
      }
      row.add(node);
    }
    if (row.elements.size() > 0) { rows.add(row); }
  }
  
  private void draw(int x, int y, int gray, ClickNet net) {
    switch(vis.v) {
      case Visibility.EXPANDED:  break;  // continue to code below
      case Visibility.COLLAPSED: return; // don't draw
      case Visibility.PARTIAL:   break;  // figure it out elsewhere
    }
    
    this.draw(x, y, gray);
    
    //draw children
    for (Row row: rows.rows) {
      int xoffset = 0;
      for (rexNode node: row.elements) {
        Rect nodeBox = new Rect(x + row.box.x + xoffset + margin,  y + row.box.y + margin, 
                                node.rows.box.w, node.rows.box.h);
        ClickNet subnet = new ClickNet(nodeBox, node);
        net.add(subnet);
        node.draw(nodeBox.x, nodeBox.y, gray + 30, subnet); // recurse
        xoffset += node.rows.box.w + margin;
      }
    }
  }
}

