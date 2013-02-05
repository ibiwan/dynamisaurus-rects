class Sz {
  int w, h;
  Sz(int wp, int hp) { w = wp; h = hp; }
  Sz copy() { return new Sz(w, h); }
}
 
class Pt {
  int x, y;
  Pt(int xp, int yp) { x = xp; y = yp; }
}

class Rect {
  int x, y, w, h;
  Rect(int xp, int yp, int wp, int hp) {
    x = xp; y = yp; 
    w = wp; h = hp;
  }
  boolean contains(Pt p) {
    if (x <= p.x && p.x <= x + w && 
        y <= p.y && p.y <= y + h) {
      return true;
    }
    return false;
  }
  void print() {
    println(x + ", " + y + "; " + w + ", " + h);
  }
}

class Row {
  Rect box;
  ArrayList<rexNode> elements = new ArrayList<rexNode>();
  Row (Pt corner) {
    box = new Rect(corner.x, corner.y, margin, margin); 
  }
  void add(rexNode node) {
    elements.add(node);
    box.w += node.rows.box.w + margin;
    box.h = max(box.h, node.rows.box.h + 2 * margin);
  }
}

class RowStack {
  Rect box;
  ArrayList<Row> rows = new ArrayList<Row>();
  RowStack (Sz min) {
    box = new Rect(0, 0, min.w, min.h); 
  }
  Pt add(Row row) {
    rows.add(row);
    box.w = max(box.w, row.box.w);
    box.h += row.box.h + margin;
    return new Pt(0, box.y + box.h);
  }
}

