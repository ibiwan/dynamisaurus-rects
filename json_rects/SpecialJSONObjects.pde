SpecialParser[] specials = {new OrderParser(), new PrimariesParser()};
HashMap<String, Integer> orderingMap = new HashMap<String, Integer>();
HashMap<String, String> primariesMap = new HashMap<String, String>();

class SpecialParser {
  String key;
  void digest(Object o) {}
}

class OrderParser extends SpecialParser {
  OrderParser() { key = "ordering"; }
  void digest(Object o) {
    for (String token: (ArrayList<String>)o) {
      orderingMap.put(token, orderingMap.size());
    }
    if (!orderingMap.containsKey("OTHER")) {
      orderingMap.put("OTHER", orderingMap.size());
    }
  }
}

class PrimariesParser extends SpecialParser {
  PrimariesParser() { key = "primaries"; }
  void digest(Object o) {
    HashMap<String, Object> primaries = (HashMap<String, Object>) o;
    for (String key: primaries.keySet()) {
      primariesMap.put(key, (String)primaries.get(key));
    }
  }
}
