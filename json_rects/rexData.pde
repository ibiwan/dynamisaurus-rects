class rexData {
  rexNode outerDisplayNode;
  rexNode innerDisplayNode;
  rexNode keyDisplayNode;
}

class rexArray extends rexData {
  ArrayList<rexData> a = new ArrayList<rexData>();
}
class rexObject extends rexData {
  HashMap<String, rexData> m = new HashMap<String, rexData>();
}

class rexBoolean extends rexData {
  Boolean b;
  rexBoolean(Boolean b_) { b = b_; }
}
class rexInteger extends rexData {
  Integer i;
  rexInteger(Integer i_) { i = i_; }
}
class rexDouble extends rexData {
  Double d;
  rexDouble(Double d_) { d = d_; }
}

