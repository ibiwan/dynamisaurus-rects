class Sz {
  int w, h;
  Sz() { w = -1; h = -1; }
  Sz(int s) { w = h = s; }
  Sz(int w, int h) { this.w = w; this.h = h; }
  
  Sz grow(Sz s)   { return new Sz(w + s.w, h + s.h); }
  //Sz grow(int a)  { return new Sz(w * a, h * a); }
  Sz div(int a)   { return new Sz(w / a, h / a); }

  Sz copy() { return new Sz(w, h); }
  Pt toPt() { return new Pt(w, h); }
}
 
class Pt {
  int x, y;
  Pt() { x = -1; y = -1; }
  Pt(int s) { x = y = s; }
  Pt(int x, int y) { this.x = x; this.y = y; }
  Pt(float[] v) { x = (int)v[0]; y = (int)v[1]; }

  Pt move(Sz s)   { return new Pt(x + s.w, y + s.h); }
  //Pt div(int a)   { return new Pt(x / a, y / a); }
}

class Rect {
  int x, y, w, h;
  Rect(Pt o, Sz s)                 { init(o.x, o.y, s.w, s.h); }
  Rect(Pt o, int w, int h)         { init(o.x, o.y,   w,   h); }
  Rect(int x, int y, Sz s)         { init(  x,   y, s.w, s.h); }
  Rect(int x, int y, int w, int h) { init(  x,   y,   w,   h); }
  
  void init(int x, int y, int w, int h) {
    this.x = x; this.y = y; this.w = w; this.h = h;
  }
  
  Pt origin() { return new Pt(x, y); }
  Sz size() { return new Sz(w, h); }
  boolean contains(Pt p) {
    if (x <= p.x && p.x <= x + w && 
        y <= p.y && p.y <= y + h)
      return true;
    return false;
  }
  Rect grow(Sz s)    { return new Rect(        origin(), w + s.w, h + s.h); }
  Rect move(Pt p)    { return new Rect(x + p.x, y + p.y, size()  ); }
  void print() { println(x + ", " + y + "; " + w + ", " + h); }
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

void rect(Rect r)         { rect(r.x, r.y, r.w, r.h); }
void line(Pt p1, Pt p2)   { line(p1.x, p1.y, p2.x, p2.y); }
void line(Pt p, Sz s)     { line(p.x, p.y, p.x + s.w, p.y + s.h); }
void saneText(String s, Pt p) { text(s, p.x, p.y + useTextSize); }

