class rexNodeGrouping extends rexNode {
  RowStack rows;  
  Row row; // your boat
  Sz min; int maxw;
  rexNodeGrouping(Sz min) {
    this.min = min;
  }
  void reset(int maxw) {
    rows = new RowStack(min);
    row = new Row(contents.nextRowLoc());
    this.maxw = maxw;
  }
}

class rexNodeRow extends rexNodeGrouping {
  rexNodeRow(Sz min) { super(min); }
  void add(rexNode node) {
    row.add(node);
  }
}

class rexNodeStack extends rexNodeGrouping {
  rexNodeStack(Sz min, int max) { super(min); }
  void add(rexNode node) {
    // make a new row after every entry);
    if ( row.count > 0 ) {
      contents.add(row);
      row = new Row(contents.nextRowLoc());
    }
  }
}

class rexNodeFill extends rexNodeGrouping {
  rexNodeFill(Sz min, int max) { super(min); }
  void add(rexNode node) {
     // make a new row any time the current one is full
     if (    maxw != -1
          && row.count > 0
          && row.bounds.w + node.contents.bounds.w + 2 * margin > maxw ) {
      contents.add(row);
      row = new Row(contents.nextRowLoc());
    }
  }
}

class Row {
  Rect bounds;
  int count = 0;
  ArrayList<rexNode> elements = new ArrayList<rexNode>();
  Row (Pt corner) {
    bounds = new Rect(corner, new Sz(margin)); 
  }
  void add(rexNode node) {
    elements.add(node);
    bounds.w += node.contents.bounds.w + margin;
    bounds.h = max(bounds.h, node.contents.bounds.h + margin);
    count++;
  }
}

class RowStack { // returns best location for next row
  int count = 0;
  Rect bounds;
  ArrayList<Row> rows = new ArrayList<Row>();
  RowStack (Sz min) { bounds = new Rect(0, 0, min); }
  void add(Row row) {
    rows.add(row);
    bounds.w = max(bounds.w, row.bounds.w);
    bounds.h += row.bounds.h + margin;
    count++;
  }
  Pt nextRowLoc() {
    return new Pt(0, bounds.y + bounds.h);
  }
}


