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

// base class for displayed nodes; loosely corresponds to nodes in data tree parsed from json

class rexNode {
  Object value;      // why we're all here
  RowStack contents; // for arranging
  
  String hint = "?";
  
  protected Sz min, max;         // stretchiness
  protected Visibility vis;      // expand/collapse state
  protected Modes arrangement;   // layout state
  protected String primary = ""; // summary field
  
  private ArrayList<rexNode> children = new ArrayList<rexNode>();  // contained nodes

  rexNode (Sz max) { init(max); }
  rexNode () { init(new Sz()); }
  private void init(Sz maxp) { 
    min = new Sz();   max = maxp;
    vis = new Visibility(Visibility.EXPANDED);
    arrangement = new Modes(Modes.PACK);
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
    stroke(gray);   fill(gray);
    rect((new Rect(new Pt(margin), contents.bounds.size()))
                  .plus(origin));
  }
  
  protected void clickReceived(Pt p) { println(this + " (" + hint + ") received click"); }
  
  protected ArrayList<String> getSummaries() { println("don't get here."); return new ArrayList<String>(); }

  private void arrange(int parent_maxw) {
    ArrayList<rexNode> use_children = children;

    // handle visibility options: expanded, collapsed, partial
    if (vis.v == Visibility.COLLAPSED) {
        contents.bounds = reduce(contents.bounds);   // shrink in a visually-pleasing manner
        return;                                      // don't pack the kids
    } else if (vis.v == Visibility.PARTIAL) {
        use_children = new ArrayList<rexNode>();
        for (String s: getSummaries()) {
          use_children.add(new rexNodeString(s));
        }
    }

    // constrain size if specified by parent
    int use_maxw = (parent_maxw == -1) ? max.w : max(max.w, parent_maxw);
    contents = new RowStack(min);
    Row row = new Row(new Pt(0, 0));

    // start fillin' rows
    for (rexNode node: use_children){
      node.arrange(use_maxw); // recurse here!
      
      // handle layout modes: row, column, best-packing
      switch (arrangement.m) {
        case Modes.PACK:
           // make a new row any time the current one is full
           if (    use_maxw != -1
                && row.elements.size() > 0
                && row.bounds.w + node.contents.bounds.w + 2 * margin > use_maxw ) {
            row = new Row(contents.add(row));
          }
          break;
        case Modes.COLUMN:
          // make a new row after every entry);
          if ( row.elements.size() > 0 ) { row = new Row(contents.add(row)); }
          break;
      }
      row.add(node);
    }
    if (row.elements.size() > 0) { contents.add(row); }
  }
  
  private void draw(Pt origin, int gray, ClickNet net) {
    if (vis.v == Visibility.COLLAPSED) { return; }
    
    this.draw(origin, gray);       // draw self
    for (Row row: contents.rows) { // draw children
      int xoffset = 0;
      for (rexNode node: row.elements) {
        Rect nodeBox = new Rect(row.bounds.origin(), node.contents.bounds.size())
                               .plus(origin)
                               .plus(new Pt(xoffset, 0))
                               .plus(new Pt(margin));
        ClickNet subNet = new ClickNet(nodeBox, node);
        net.add(subNet);
        node.draw(nodeBox.origin(), gray + 20, subNet); // recurse
        xoffset += node.contents.bounds.w + margin;
      }
    }
  }
}

