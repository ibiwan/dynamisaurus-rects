// this field is literally the only reason all these classes exist.
class rexData {
  rexNodeKey keyDisplayNode;
}

// wrappers not children because String is "final".  stupid String.

class rexArray extends rexData {
  ArrayList<rexData> a = new ArrayList<rexData>();
}
class rexObject extends rexData {
  HashMap<String, rexData> m = new HashMap<String, rexData>();
  String[] keys() { return m.keySet().toArray(new String[0]); }
}

class rexString  extends rexData { String s;  rexString (String  s_) { s = s_; } }
class rexBoolean extends rexData { Boolean b; rexBoolean(Boolean b_) { b = b_; } }
class rexInteger extends rexData { Integer i; rexInteger(Integer i_) { i = i_; } }
class rexDouble  extends rexData { Double d;  rexDouble (Double  d_) { d = d_; } }

