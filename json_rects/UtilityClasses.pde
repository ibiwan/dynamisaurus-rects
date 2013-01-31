class Sz {
  int w, h;
  Sz(int wp, int hp) { w = wp; h = hp; }
  Sz copy()  { return new Sz(w, h); }
}

class Pt {
  int x, y;
  Pt(int xp, int yp) { x = xp; y = yp; }
}

class Box {
  int x, y, w, h;
  Box(int xp, int yp, int wp, int hp) {
    x = xp; y = yp; w = wp; h = hp;
    //println(x + " " + y + " " + w + " " + h);
  }
  boolean contains(Pt p) {
    if (x <= p.x && p.x <= x + w && 
        y <= p.y && p.y <= y + h) {
      return true; 
    }
    return false;
  }
  void printout() {
    println(x + ", " + y + "; " + w + ", " + h);
  }
}

class Row {
  Box box;
  JSONode[] elements = {};
  Row (Pt corner) { 
    //println(corner.x + " " + corner.y);
    box = new Box(corner.x, corner.y, margin, margin); 
    //box.printout();
  }
  void add(JSONode node) {
    elements = (JSONode[]) append(elements, node);
    box.w += node.cur.w + margin;
    box.h = max(box.h, node.cur.h + 2 * margin);
    //box.printout();
  }
}

class IndexedObject implements Comparable {
  int index; Object object;
  IndexedObject(int i, Object o) { index = i; object = o; }
  int compareTo(Object o) {
    IndexedObject other=(IndexedObject)o;
    if(other.index > index)  return -1;
    if(other.index == index) return 0;
    else                     return 1;
  }
}

