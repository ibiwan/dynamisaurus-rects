class Sz {
  int w, h;
  Sz(int wp, int hp) { 
    w = wp; 
    h = hp;
  }
  Sz copy() { 
    return new Sz(w, h);
  }
}

class Pt {
  int x, y;
  Pt(int xp, int yp) { 
    x = xp; 
    y = yp;
  }
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
  ArrayList<JSONode> elements = new ArrayList<JSONode>();
  Row (Pt corner) {
    box = new Rect(corner.x, corner.y, margin, margin); 
  }
  void add(JSONode node) {
    elements.add(node);
    box.w += node.cur.w + margin;
    box.h = max(box.h, node.cur.h + 2 * margin);
  }
}

