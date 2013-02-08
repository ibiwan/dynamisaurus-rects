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
  Object value;      // why we're all here
  RowStack rows;     // for arranging
  
  String hint = "";
  
  protected Sz min, max;         // stretchiness
  protected Visibility vis;      // expand/collapse state
  protected Modes arrangement;   // layout state
  protected String primary = ""; // summary field
  
  private ArrayList<rexNode> children = new ArrayList<rexNode>();  // contained nodes

  rexNode (Sz max) { init(max); }
  rexNode () { init(new Sz(-1, -1)); }
  private void init(Sz maxp) { 
    min = new Sz(-1, -1);   max = maxp;
    vis = new Visibility(Visibility.EXPANDED);
    arrangement = new Modes(Modes.PACK);
  }
  
  void addChild(rexNode node) {
    try {
      children.add(node);
    }
    catch (Exception e) {
      println("Exception adding child to node");
      e.printStackTrace();
    }
  }
  
  void drawasroot(int x, int y, int gray) {
    clickRoot = new ClickNet(new Rect(x, y, max.w, max.h), this);
    arrange(max.w);              // one pass to organize everything
    draw(x, y, gray, clickRoot); // second pass to put on screen
  }
  
  protected void draw(int x, int y, int gray) {
    stroke(gray);   fill(gray);
    rect(x + margin, y + margin, rows.box.w, rows.box.h);
  }
  
  protected void clickReceived(Pt p) { println(this + " (" + hint + ") received click"); }
  
  protected ArrayList<String> getSummaries() { println("don't get here."); return new ArrayList<String>(); }

  private void arrange(int parent_maxw) {
    ArrayList<rexNode> use_children = children;

    if (vis.v == Visibility.COLLAPSED) {
        rows.box = reduce(rows.box);   // shrink in a visually-pleasing manner
        return;                        // don't pack the kids
    } else if (vis.v == Visibility.PARTIAL) {
        use_children = new ArrayList<rexNode>();
        for (String s: getSummaries()) {
          use_children.add(new rexNodeString(s));
        }
    }

    int use_maxw = (parent_maxw == -1) ? max.w : max(max.w, parent_maxw);
    rows = new RowStack(min);
    Row row = new Row(new Pt(0, 0));

    for (rexNode node: use_children){
      node.arrange(use_maxw); // recurse here!
      switch (arrangement.m) {
        case Modes.PACK:     // make a new row any time the current one is full
           if (    use_maxw != -1 && row.elements.size() > 0
                && row.box.w + node.rows.box.w + 2 * margin > use_maxw ) {
            row = new Row(rows.add(row));
          }
          break;
        case Modes.COLUMN:  // make a new row after every entry);
          if ( row.elements.size() > 0 ) { row = new Row(rows.add(row)); }
          break;
      }
      row.add(node);
    }
    if (row.elements.size() > 0) { rows.add(row); }
  }
  
  private void draw(int x, int y, int gray, ClickNet net) {
    if (vis.v == Visibility.COLLAPSED) { return; }
    
    this.draw(x, y, gray);     // draw self
    for (Row row: rows.rows) { // draw children
      int xoffset = 0;
      for (rexNode node: row.elements) {
        Rect nodeBox = new Rect(x + row.box.x + xoffset + margin,  y + row.box.y + margin, 
                                node.rows.box.w,                   node.rows.box.h);
        ClickNet subNet = new ClickNet(nodeBox, node);
        net.add(subNet);
        node.draw(nodeBox.x, nodeBox.y, gray + 20, subNet); // recurse
        xoffset += node.rows.box.w + margin;
      }
    }
  }
}

