// this field is literally the only reason all these classes exist.
class rexData {
  rexNodeKey keyDisplayNode;
}

// wrappers, not children, because String is "final".  stupid String.

class rexArray extends rexData {
  ArrayList<rexData> a = new ArrayList<rexData>();
}

class rexObject extends rexData {
  rexObject() {}
  rexObject (rexObject other) {
    keyDisplayNode = other.keyDisplayNode;
    m = other.m;
  }
  HashMap<String, rexData> m = new HashMap<String, rexData>();
  String[] keys() { return m.keySet().toArray(new String[0]); }
}

class rexString  extends rexData { String s;  rexString (String  s) { this.s = s; } }
class rexBoolean extends rexData { Boolean b; rexBoolean(Boolean b) { this.b = b; } }
class rexInteger extends rexData { Integer i; rexInteger(Integer i) { this.i = i; } }
class rexDouble  extends rexData { Double d;  rexDouble (Double  d) { this.d = d; } }

