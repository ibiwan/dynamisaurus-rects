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

