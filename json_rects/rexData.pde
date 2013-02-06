class rexData {
  rexNode outerDisplayNode;
  rexNode innerDisplayNode;
}

class rexArray extends rexData {
  ArrayList<rexData> a = new ArrayList<rexData>();
  void add(rexData o) { a.add(o); }
}

class rexObject extends rexData {
  HashMap<String, rexData> m = new HashMap<String, rexData>();
  void put(String key, rexData o) { m.put(key, o); }
  boolean containsKey(String key) { return m.containsKey(key); }
  Object get(String key) { return m.get(key); }
  void remove(String key) { m.remove(key); }
}

class rexString extends rexData {
  String s;
  rexString(String s_) { s = s_; }
}

class rexScalar extends rexData {
  Object s;
  rexScalar(Object o) { s = o; }
}

