//this sucks.  is there a better enum?

class States {
  final static int EXPANDED  =1;
  final static int COLLAPSED = 2;
  final static int PARTIAL   = 3;
  int s;
  States(int s_) { s = s_; }
}

class Modes {
  final static int PACK   = 1;
  final static int COLUMN = 2;
  final static int ROW    = 3;
  int m;
  Modes(int m_) { m = m_; }
}

class JSONode {
  /*--------PUBLIC-------*/
  States state = new States(States.EXPANDED); //collapsed, partial_array
  Object value;
  JSONode (Sz min, Sz max) { init(min, max); }
  JSONode (JSONode parent) { 
    init(new Sz(-1, -1), new Sz(-1, -1)); 
    parent.addChild(this);
  }
  
  void addChild(JSONode node) {
    try {
      node.parent = this;
      children.add(node);
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }
  void drawasroot(int x, int y, int gray) {
    clickRoot = new ClickNet(new Box(x, y, max.w, max.h), this);
    arrangeChildren(max.w); // not called from draw directly as it needs to be done only once
    draw(x, y, gray, clickRoot);
  }
  
  /*--------PROTECTED-------*/
  protected Sz min, max, cur;
  protected JSONode parent;
  protected Modes arrangement = new Modes(Modes.PACK);
  protected String primary = "";

  protected void drawSelf(int x, int y, int gray) {
    stroke(gray);
    fill(gray);
    rect(x + margin, y + margin, cur.w, cur.h);
  }
  
  protected void clickReceived(Pt p) {
    /* implement where appropriate in child classes */
  }
  
  /*--------PRIVATE-------*/
  private ArrayList<Row> rows;
  private ArrayList<JSONode> children = new ArrayList<JSONode>();
  private int my_gray = 0;
  
  private void init(Sz minp, Sz maxp) { min = minp; max = maxp; my_gray = (int)random(125, 255); }
  
  private void arrangeChildren(int parent_maxw) {
    switch(state.s) {
      case States.EXPANDED:
        // handle below
        break;
      case States.COLLAPSED:
        // shrink in a visually-pleasing manner
        cur.w = reduce(cur.w);
        cur.h = reduce(cur.h);
        // don't pack the kids
        return;
      case States.PARTIAL:
        summarize(parent_maxw);
        return;
    }
    switch (arrangement.m) {
      case Modes.PACK:   pack (parent_maxw); break;
      case Modes.COLUMN: stack(parent_maxw); break;
      case Modes.ROW:    chain(parent_maxw); break;
    }
  }
 
  private void pack(int parent_maxw) {
    rows = new ArrayList<Row>();
    Row row = new Row(new Pt(0, 0));
    cur = min.copy();
    int use_maxw = (parent_maxw == -1) ? max.w : max(max.w, parent_maxw);
    
    for (int i = 0; i < children.size(); i++) {
      JSONode node = children.get(i);
      node.arrangeChildren(use_maxw); // recurse here!
      if (     use_maxw != -1
            && row.elements.size() > 0
            && row.box.w + node.cur.w + 2 * margin > use_maxw ) {
        rows.add(row);
        cur.w = max(cur.w, row.box.w);
        Pt pt = new Pt(0, row.box.y + row.box.h - margin);
        row = new Row(pt);
      }
      row.add(node);
    }
    
    cur.h = max(cur.h, row.box.y + row.box.h);
    if (row.elements.size() > 0) {
      rows.add(row);
      cur.w = max(cur.w, row.box.w);
    }
  }
  
  private void stack(int parent_maxw) {
    rows = new ArrayList<Row>();
    Row row = new Row(new Pt(0, 0));
    cur = min.copy();
    int use_maxw = parent_maxw == -1 ? max.w : max(max.w, parent_maxw);
    for (int i = 0; i < children.size(); i++) {
      JSONode node = children.get(i);
      node.arrangeChildren(use_maxw); // recurse here!
      if ( row.elements.size() > 0 ) {
        cur.w = max(cur.w, row.box.w);
        rows.add(row);
        row = new Row(new Pt(0, row.box.y + row.box.h - margin));
      }
      row.add(node);
    }
    cur.h = max(cur.h, row.box.y + row.box.h);
    if (row.elements.size() > 0) {
      rows.add(row);
      cur.w = max(cur.w, row.box.w);
    }
  }
  
  private void chain(int parent_maxw) {
    rows = new ArrayList<Row>();
    Row row = new Row(new Pt(0, 0));
    cur = min.copy();
    int use_maxw = (parent_maxw == -1) ? max.w : max(max.w, parent_maxw);
    
    for (int i = 0; i < children.size(); i++) {
      JSONode node = children.get(i);
      node.arrangeChildren(use_maxw); // recurse here!
      row.add(node);
    }
    
    cur.h = max(cur.h, row.box.y + row.box.h);
    if (row.elements.size() > 0) {
      rows.add(row);
      cur.w = max(cur.w, row.box.w);
    }
  }
  
  private void summarize(int parent_maxw) {
    rows = new ArrayList<Row>();
    Row row = new Row(new Pt(0, 0));
    cur = min.copy();
    int use_maxw = parent_maxw == -1 ? max.w : max(max.w, parent_maxw);
    for (int i = 0; i < children.size(); i++) {
      JSONode node = children.get(i);
      node.arrangeChildren(use_maxw); // recurse here!
      if ( row.elements.size() > 0 ) {
        cur.w = max(cur.w, row.box.w);
        rows.add(row);
        row = new Row(new Pt(0, row.box.y + row.box.h - margin));
      }
      row.add(node);
    }
    cur.h = max(cur.h, row.box.y + row.box.h);
    if (row.elements.size() > 0) {
      rows.add(row);
      cur.w = max(cur.w, row.box.w);
    }
  }
  
  private void draw(int x, int y, int gray, ClickNet net) {
    switch(state.s) {
      case States.EXPANDED:
        // continue to code below
        break;
      case States.COLLAPSED:
        return;
      case States.PARTIAL:
        //figure it out elsewhere
        break;
    }
    drawSelf(x, y, gray);
    
    //draw children
    for (int i = 0; i < rows.size(); i++) {
      Row row = rows.get(i);
      int xoffset = 0;
      for (int j = 0; j < row.elements.size(); j++) {
        JSONode node = row.elements.get(j);
        Box nodeBox = new Box(x + row.box.x + xoffset + margin,  y + row.box.y + margin, 
                             node.cur.w, node.cur.h);
        ClickNet subnet = new ClickNet(nodeBox, node);
        net.add(subnet);
        node.draw(nodeBox.x, nodeBox.y, gray + 30, subnet); // recurse
        xoffset += node.cur.w + margin;
      }
    }
  }
}

