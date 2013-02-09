abstract class SpecialParser {
  String key;
  abstract void digest(rexData o);
  void chew(rexObject hm) {
    if (hm.m.containsKey(key)) {
      digest((rexData)hm.m.get(key));
      hm.m.remove(key);
    }
  }
}
SpecialParser[] specials = {new OrderParser(), new PrimariesParser()};

String ORDERING_OTHER = "REX_OTHER";
class OrderParser extends SpecialParser {
  
  OrderParser() { /***/ key = "rex-ordering"; /***/ }
  
  void digest(rexData d) {
    for (Object token: ((rexArray)d).a)
      orderingMap.put(((rexString)token).s, orderingMap.size());
    if (!orderingMap.containsKey(ORDERING_OTHER))
      orderingMap.put(ORDERING_OTHER, orderingMap.size());
  }
}
HashMap<String, Integer> orderingMap = new HashMap<String, Integer>();

class PrimariesParser extends SpecialParser {
  
  PrimariesParser() { /***/ key = "rex-primaries"; /***/ }
  
  void digest(rexData d) {
    HashMap<String, rexData> primaries = ((rexObject)d).m;
    for (String key: primaries.keySet()) {
      rexString field = (rexString)primaries.get(key);
      primariesMap.put(key, field.s);
    }
  }
}
HashMap<String, String> primariesMap = new HashMap<String, String>();

