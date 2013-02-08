class Sz {
  int w, h;
  Sz() { w = -1; h = -1; }
  Sz(int wp, int hp) { w = wp; h = hp; }
  Sz copy() { return new Sz(w, h); }
  Pt toPt() { return new Pt(w, h); }
  Sz plus(Sz s)   { return new Sz(w + s.w, h + s.h); }
  Sz minus(Sz s)  { return new Sz(w - s.w, h - s.h); }
  Sz times(int a) { return new Sz(w * a, h * a); }
  Sz div(int a)   { return new Sz(w / a, h / a); }
}
 
class Pt {
  int x, y;
  Pt() { x = -1; y = -1; }
  Pt(int xp, int yp) { x = xp; y = yp; }
  Sz toSz() { return new Sz(x, y); }
  Pt plus(Pt p)   { return new Pt(x + p.x, y + p.y); }
  Pt minus(Pt p)  { return new Pt(x - p.x, y - p.y); }
  Pt times(int a) { return new Pt(x * a, y * a); }
  Pt div(int a)   { return new Pt(x / a, y / a); }
}

class Rect {
  int x, y, w, h;
  Rect(Pt orig, Sz s) {
    x = orig.x; y = orig.y;   w = s.w; h = s.h;
  }
  Rect(Pt orig, int wp, int hp) {
    x = orig.x; y = orig.y;   w = wp; h = hp;
  }
  Rect(int xp, int yp, Sz s) {
    x = xp; y = yp;   w = s.w; h = s.h;
  }
  Rect(int xp, int yp, int wp, int hp) {
    x = xp; y = yp;   w = wp; h = hp;
  }
  Pt orig() { return new Pt(x, y); }
  Sz size() { return new Sz(w, h); }
  boolean contains(Pt p) {
    if (x <= p.x && p.x <= x + w && 
        y <= p.y && p.y <= y + h) {
      return true;
    }
    return false;
  }
  Rect plus(Rect r)  { return new Rect(x + r.x, y + r.y, w + r.w, h + r.h); }
  Rect plus(Sz s)    { return new Rect(x      , y      , w + s.w, h + s.h); }
  Rect plus(Pt p)    { return new Rect(x + p.x, y + p.y, w      , h      ); }
  Rect minus(Rect r) { return new Rect(x - r.x, y - r.y, w - r.w, h - r.h); }
  Rect minus(Sz s)   { return new Rect(x      , y      , w - s.w, h - s.h); }
  Rect minus(Pt p)   { return new Rect(x - p.x, y - p.y, w      , h      ); }
  void print() { println(x + ", " + y + "; " + w + ", " + h); }
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
  RowStack (Sz min) { box = new Rect(0, 0, min.w, min.h); }
  Pt add(Row row) {
    rows.add(row);
    box.w = max(box.w, row.box.w);
    box.h += row.box.h + margin;
    return new Pt(0, box.y + box.h);
  }
}

