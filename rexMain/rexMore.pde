class rexNodeString extends rexNode {
  rexNodeString (String s)  { 
    super();
    hint = "string";
    value = s;
    int w = (s != null) ? (int)textWidth(s) : 0;
    min = new Sz(w, useTextSize)
                .plus(new Sz(margin, margin)
                            .times(2));
  }
  protected void draw(Pt orig, int gray) {
    draw((String)value, orig, gray);
  }
  protected void draw(String useStr, Pt orig, int gray) {
    super.draw(orig, gray);
    
    fill(0);
    text(useStr, (new Pt(2 * margin, margin + useTextSize))
                        .plus(orig));

    noFill(); stroke(gray);
    rect((new Rect(margin, margin, rows.box.size()))
                  .plus(orig));
  }
}

class rexNodeObject extends rexNode {
  rexObject backingData;
  rexNodeObject() { super(); hint = "object"; }

  protected ArrayList<String> getSummaries() {
    int i = 0;
    ArrayList<String> ret = new ArrayList<String>();
    for (String s: backingData.m.keySet()) {
      println("s:" + s);
    }
    println("primary: " + primary);
    // <<FIXME>> get object label from containing array's kb.collection,primary
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
    ret.add("hey, there");
    return ret;
  }
}

class rexNodeArray extends rexNode {
  rexArray backingData;
  rexNodeArray ()  { 
    super(); hint = "array";
    arrangement.m = Modes.COLUMN;
  }
  protected void draw(Pt orig, int gray) {
    stroke(gray);   fill(gray);
    Rect r = (new Rect(orig, rows.box.size()))
                      .plus(new Sz(margin, margin).times(2));
    rect(r);
  }
  protected ArrayList<String> getSummaries() {
    int i = 0; String use_str;
    ArrayList<String> ret = new ArrayList<String>();
    for (rexData d: backingData.a) {
      if (d instanceof rexObject) { // for each array child, look for its "display" field
        use_str = "" + i++;
        if (((rexObject)d).m.containsKey(primary)) {
          rexData value = ((rexObject)d).m.get(key);
          if (value instanceof rexString) { // <<FIXME>> handle other data types too
            use_str = ((rexString)value).s;
            break;
          }          
        }
        ret.add(use_str);
      }
    }
    return ret;
  }
}

class rexNodeWrapper extends rexNodeArray {
  rexNodeWrapper(int m) { super(); hint = "wrapper"; arrangement.m = m; }
}

class rexNodeInt    extends rexNodeString{ rexNodeInt   (rexInteger i) { super(i.i.toString()); hint = "int"; } }
class rexNodeBool   extends rexNodeString{ rexNodeBool  (rexBoolean b) { super(b.b.toString()); hint = "bool"; } }
class rexNodeDouble extends rexNodeString{ rexNodeDouble(rexDouble  d) { super(d.d.toString()); hint = "double"; } }

