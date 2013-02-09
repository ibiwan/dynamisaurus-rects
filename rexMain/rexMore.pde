class rexNodeString extends rexNode {
  boolean       displayKey = true;
  rexNodeString (String s)            { super(); init(s, true); }
  rexNodeString (String s, boolean d) { super(); init(s, d);    }
  void init(String s, boolean d) {
    hint = "string";
    value = s;
    displayKey = d;
    int w = (s != null && displayKey == true) ? (int)textWidth(s) : 0;
    min = new Sz(w, useTextSize)
                .plus(new Sz(margin));
  }
  protected void draw(Pt origin, int gray) {
    draw((String)value, origin, gray);
  }
  protected void draw(String t, Pt origin, int gray) {
    super.draw(origin, gray);
    
    if (displayKey) {
      fill(0);
      text(t, (new Pt(2 * margin, margin + useTextSize))
                     .plus(origin));
    }
    
    noFill(); stroke(gray);
    rect((new Rect(new Pt(margin), contents.bounds.size()))
                  .plus(origin));
  }
}

class rexNodeObject extends rexNode {
  rexObject backingData;
  rexNodeObject() { super(); hint = "object"; }

  protected ArrayList<String> getSummaries() {
    int i = 0;
    ArrayList<String> ret = new ArrayList<String>();
    if (backingData.m.containsKey(primary)) {
      ret.add (((rexString)backingData.m.get(primary)).s);
    }
    return ret;
  }
}

class rexNodeArray extends rexNode {
  rexArray backingData;
  rexNodeArray ()  { 
    super(); hint = "array";
    arrangement.m = Modes.COLUMN;
  }
  protected void draw(Pt origin, int gray) {
    stroke(gray);   fill(gray);
    Rect r = (new Rect(origin, contents.bounds.size()))
                      .plus(new Sz(margin));
    rect(r);
  }
  protected ArrayList<String> getSummaries() {
    int i = 0; String use_str;
    ArrayList<String> ret = new ArrayList<String>();
    for (rexData d: backingData.a) {
      if (d instanceof rexObject) { // for each array child, look for its "display" field
        use_str = "" + i++;
        if (((rexObject)d).m.containsKey(primary)) {
          rexData value = ((rexObject)d).m.get(primary);
          if (value instanceof rexString) { // <<FIXME>> handle other data types too
            use_str = ((rexString)value).s;
            ret.add(use_str);
          }          
        }
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

