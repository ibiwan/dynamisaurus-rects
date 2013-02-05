class rexNodeString extends rexNode {
  rexNodeString (rexNode parent, String s)  { 
    super(parent);
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
    rect(x + margin, y + margin, rows.box.w,rows.box.h);
  }
}

class rexNodeArray extends rexNode {
  rexNodeArray (rexNode parent)  { 
    super(parent); 
    arrangement.m = Modes.COLUMN;
  }
  protected void draw(int x, int y, int gray) {
    stroke(127); fill(gray);
    rect(x, y, rows.box.w + 2 * margin, rows.box.h + 2 * margin);
    
    if (parent.primary != "") {
      println(parent.primary);
    }
  }
}

class rexNodeInt    extends rexNodeString{ rexNodeInt   (rexNode parent, Integer i) { super(parent, i.toString()); } }
class rexNodeBool   extends rexNodeString{ rexNodeBool  (rexNode parent, Boolean b) { super(parent, b.toString()); } }
class rexNodeDouble extends rexNodeString{ rexNodeDouble(rexNode parent, Double  d) { super(parent, d.toString()); } }
class rexNodeObject extends rexNode{  rexNodeObject(rexNode parent) { super(parent); } }

