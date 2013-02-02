HashMap<String, Integer> orderingMap;
HashMap<String, String>  primariesMap;

HashMap parseOrdering(ArrayList ordering) {
  HashMap<String, Integer> orderingMap = new HashMap<String, Integer>();
  int i;
  for (i = 0; i < ordering.size(); i++) {
    String token = (String)ordering.get(i);
    orderingMap.put(token, i);
  }
  if (!orderingMap.containsKey("OTHER")) {
    orderingMap.put("OTHER", i);
  }
  return orderingMap;
}

HashMap parsePrimaries(HashMap<String, Object> primaries) {
  HashMap<String, String> primariesMap = new HashMap<String, String>();
  Iterator i = primaries.entrySet().iterator();
  while (i.hasNext()) {
    Map.Entry me = (Map.Entry)i.next();
    primariesMap.put((String)me.getKey(), (String)me.getValue());
  }
  return primariesMap;
}

