class rexNodeString extends rexNode {
  rexNodeString (String s)  { 
    super(new Sz(-1, -1), new Sz(-1, -1)); 
    value = s;
    min.w = (int)textWidth(s) + 2 * margin;
    min.h = useTextSize + 2 * margin;
  }
  protected void draw(int x, int y, int gray) {
    draw((String)value, x, y, gray);
  }
  protected void draw(String useStr, int x, int y, int gray) {
    super.draw(x, y, gray);
    
    fill(0);
    text(useStr, x + 2 * margin, y + margin + useTextSize);

    noFill();
    stroke(gray);
    rect(x + margin, y + margin, cur.w, cur.h);
  }
}

class rexNodeArray extends rexNode {
  rexNodeArray (rexNode parent)  { 
    super(parent); 
    arrangement.m = Modes.COLUMN;
  }
  protected void draw(int x, int y, int gray) {
    stroke(127); fill(gray);
    rect(x, y, cur.w + 2 * margin, cur.h + 2 * margin);
    if (parent.primary != "") {
      println(parent.primary);
    }
  }
}

class rexNodeInt    extends rexNodeString{ rexNodeInt   (Integer i) { super(i.toString()); } }
class rexNodeBool   extends rexNodeString{ rexNodeBool  (Boolean b) { super(b.toString()); } }
class rexNodeDouble extends rexNodeString{ rexNodeDouble(Double  d) { super(d.toString()); } }
class rexNodeObject extends rexNode{  rexNodeObject(rexNode parent) { super(parent); } }

