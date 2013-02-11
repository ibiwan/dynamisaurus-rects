class Sz {
  int w, h;
  Sz() { w = -1; h = -1; }
  Sz(int s) { w = s; h = s; }
  Sz(int w_, int h_) { w = w_; h = h_; }
  
  Sz plus(Sz s)   { return new Sz(w + s.w, h + s.h); }
  Sz minus(Sz s)  { return new Sz(w - s.w, h - s.h); }
  Sz times(int a) { return new Sz(w * a, h * a); }
  Sz div(int a)   { return new Sz(w / a, h / a); }

  Sz copy() { return new Sz(w, h); }
  Pt toPt() { return new Pt(w, h); }
}
 
class Pt {
  int x, y;
  Pt() { x = -1; y = -1; }
  Pt(int s) { x = s; y = s; }
  Pt(int x_, int y_) { x = x_; y = y_; }

  Pt plus(Sz s)   { return new Pt(x + s.w, y + s.h); }
  Pt minus(Sz s)  { return new Pt(x - s.w, y - s.h); }
  Pt times(int a) { return new Pt(x * a, y * a); }
  Pt div(int a)   { return new Pt(x / a, y / a); }

  Sz toSz() { return new Sz(x, y); }
}

class Rect {
  int x, y, w, h;
  Rect(Pt o, Sz s)                     { init(o.x, o.y, s.w, s.h); }
  Rect(Pt o, int w_, int h_)           { init(o.x, o.y,  w_,  h_); }
  Rect(int x_, int y_, Sz s)           { init( x_,  y_, s.w, s.h); }
  Rect(int x_, int y_, int w_, int h_) { init( x_,  y_,  w_,  h_); }
  
  void init(int x_, int y_, int w_, int h_) {
    x = x_; y = y_; w = w_; h = h_;
  }
  
  Pt origin() { return new Pt(x, y); }
  Sz size() { return new Sz(w, h); }
  boolean contains(Pt p) {
    if (x <= p.x && p.x <= x + w && 
        y <= p.y && p.y <= y + h)
      return true;
    return false;
  }
  Rect plus(Rect r)  { return new Rect(x + r.x, y + r.y, w + r.w, h + r.h); }
  Rect plus(Sz s)    { return new Rect(        origin(), w + s.w, h + s.h); }
  Rect plus(Pt p)    { return new Rect(x + p.x, y + p.y, w      , h      ); }
  Rect minus(Rect r) { return new Rect(x - r.x, y - r.y, w - r.w, h - r.h); }
  Rect minus(Sz s)   { return new Rect(x      , y      , w - s.w, h - s.h); }
  Rect minus(Pt p)   { return new Rect(x - p.x, y - p.y, w      , h      ); }
  void print() { println(x + ", " + y + "; " + w + ", " + h); }
}

class Row {
  Rect bounds;
  ArrayList<rexNode> elements = new ArrayList<rexNode>();
  Row (Pt corner) {
    bounds = new Rect(corner, new Sz(margin)); 
  }
  void add(rexNode node) {
    elements.add(node);
    bounds.w += node.contents.bounds.w + margin;
    bounds.h = max(bounds.h, node.contents.bounds.h + margin);
  }
}

class RowStack { // returns best location for next row
  Rect bounds;
  ArrayList<Row> rows = new ArrayList<Row>();
  RowStack (Sz min) { bounds = new Rect(0, 0, min); }
  void add(Row row) {
    rows.add(row);
    bounds.w = max(bounds.w, row.bounds.w);
    bounds.h += row.bounds.h + margin;
  }
  Pt nextRowLoc() {
    return new Pt(0, bounds.y + bounds.h);
  }
}

