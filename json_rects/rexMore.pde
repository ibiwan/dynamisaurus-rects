class rexNodeString extends rexNode {
  rexNodeString (String s)  { 
    super();
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

class rexNodeObject extends rexNode {
  rexObject backingData;
  rexNodeObject() { super(); }

  protected ArrayList<String> getSummaries() {
    int i = 0;
    ArrayList<String> ret = new ArrayList<String>();
    for (String s: backingData.m.keySet()) {
      println("s:" + s);
    }
    /*for (rexNode n: children) {    // use labels instead of full objects
      String use_str = "" + i++;
      for (rexNode c: n.children) {
        if (c.keyBox != null && ((String)c.keyBox.value).equals(primary)) {
          use_str = (String)(c.children.get(1).value);
          break;
        }
      }
      ret.add(use_str);
    }*/
    return ret;
  }
}

class rexNodeArray extends rexNode {
  rexArray backingData;
  rexNodeArray ()  { 
    super();
    arrangement.m = Modes.COLUMN;
  }
  protected void draw(int x, int y, int gray) {
    stroke(127);   fill(gray);
    rect(x, y, rows.box.w + 2 * margin, rows.box.h + 2 * margin);
  }
  protected ArrayList<String> getSummaries() {
    int i = 0;
    ArrayList<String> ret = new ArrayList<String>();
    for (rexData d: backingData.a) {
      println(d); // <<FIXME>> this is where you left off
    }
    /*for (rexNode n: children) {    // use labels instead of full objects
      String use_str = "" + i++;
      for (rexNode c: n.children) {
        if (c.keyBox != null && ((String)c.keyBox.value).equals(primary)) {
          use_str = (String)(c.children.get(1).value);
          break;
        }
      }
      ret.add(use_str);
    }*/
    return ret;
  }
}

class rexNodeWrapper extends rexNodeArray {
}

class rexNodeInt    extends rexNodeString{ rexNodeInt   (rexInteger i) { super(i.i.toString()); } }
class rexNodeBool   extends rexNodeString{ rexNodeBool  (rexBoolean b) { super(b.b.toString()); } }
class rexNodeDouble extends rexNodeString{ rexNodeDouble(rexDouble  d) { super(d.d.toString()); } }


