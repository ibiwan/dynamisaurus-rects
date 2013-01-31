HashMap<String, Integer> orderingMap;
HashMap<String, String>  primariesMap;

HashMap parseOrdering(JSONArray ordering) {
  HashMap<String, Integer> orderingMap = new HashMap<String, Integer>();
  try {
    int i;
    for (i = 0; i < ordering.length(); i++) {
      String token = ordering.getString(i);
      orderingMap.put(token, i);
    }
    if (!orderingMap.containsKey("OTHER")) {
      orderingMap.put("OTHER", i);
    }
  }
  catch (JSONException e) {
    println ("There was an error parsing the JSONObject.");
    println(e.toString());
  };
  return orderingMap;
}

HashMap parsePrimaries(JSONObject primaries) {
  HashMap<String, String> primariesMap = new HashMap<String, String>();
  try {
    for (int i = 0; i < primaries.length(); i++) {
      String[] keys = primaries.getNames(primaries);
      for (int j = 0; j < keys.length; j++) {
        String key = keys[j];
        primariesMap.put(key, primaries.getString(key));
      }
    }
  }
  catch (JSONException e) {
    println ("There was an error parsing the JSONObject.");
    println(e.toString());
  }
  return primariesMap;
}

