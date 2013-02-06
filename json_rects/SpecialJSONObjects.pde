SpecialParser[] specials = {new OrderParser(), new PrimariesParser()};
HashMap<String, Integer> orderingMap = new HashMap<String, Integer>();
HashMap<String, String> primariesMap = new HashMap<String, String>();

String ORDERING_OTHER = "OTHER";

abstract class SpecialParser {
  String key;
  abstract void digest(rexData o);
  void chew(rexObject hm) {
    if (hm.m.containsKey(key)) {
      digest((rexData)hm.m.get(key));
      hm.m.remove(key);
    } else {
    }
  }
}

class OrderParser extends SpecialParser {
  OrderParser() { key = "rex-ordering"; }
  void digest(rexData d) {
    rexArray a = (rexArray)d;
    for (Object token: (a.a)) {
      String key = ((rexString)token).s;
      orderingMap.put(key, orderingMap.size());
    }
    if (!orderingMap.containsKey(ORDERING_OTHER)) {
      orderingMap.put(ORDERING_OTHER, orderingMap.size());
    }
  }
}

class PrimariesParser extends SpecialParser {
  PrimariesParser() { key = "rex-primaries"; }
  void digest(rexData d) {
    rexObject o = (rexObject)d;
    HashMap<String, rexData> primaries = o.m;
    for (String key: primaries.keySet()) {
      rexString field = (rexString)primaries.get(key);
      primariesMap.put(key, field.s);
    }
  }
}

