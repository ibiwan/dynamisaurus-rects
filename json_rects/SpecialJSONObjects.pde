SpecialParser[] specials = {new OrderParser(), new PrimariesParser()};
HashMap<String, Integer> orderingMap = new HashMap<String, Integer>();
HashMap<String, String> primariesMap = new HashMap<String, String>();

String ORDERING_OTHER = "OTHER";

class SpecialParser {
  String key;
  void digest(Object o) {}
  void chew(HashMap<String, Object> hm) {
    if (hm.containsKey(key)) {
      digest(hm.get(key));
      hm.remove(key);
    }
  }
}

class OrderParser extends SpecialParser {
  OrderParser() { key = "rex-ordering"; }
  void digest(Object o) {
    for (String token: (ArrayList<String>)o) {
      orderingMap.put(token, orderingMap.size());
    }
    if (!orderingMap.containsKey(ORDERING_OTHER)) {
      orderingMap.put(ORDERING_OTHER, orderingMap.size());
    }
  }
}

class PrimariesParser extends SpecialParser {
  PrimariesParser() { key = "rex-primaries"; }
  void digest(Object o) {
    HashMap<String, Object> primaries = (HashMap<String, Object>) o;
    for (String key: primaries.keySet()) {
      primariesMap.put(key, (String)primaries.get(key));
    }
  }
}

