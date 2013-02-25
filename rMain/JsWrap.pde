void handleJsonException(Exception e) {
  println ("There was an error parsing the JSONObject.");
  println(e.toString());
  e.printStackTrace();
}

rexObject parseJsonObject(String s) {
  try {
    println("parsing: " + s + "\n");
    JSONObject j = JSONObject.parse(s);
    //println("translating: " + j + "\n");
    //return translateJsonObject(j);
  } 
  catch (Exception e) { 
    handleJsonException(e);
  }
  return new rexObject();
}

rexData translateJsonSomething(Object o) throws Exception {
  println("translating unknown json thing");
  if (o instanceof JSONArray) { 
    return translateJsonArray ((JSONArray) o);
  }
  if (o instanceof JSONObject) { 
    return translateJsonObject((JSONObject)o);
  }
  if (o instanceof Boolean) { 
    return new rexBoolean((Boolean)o);
  }
  if (o instanceof Integer) { 
    return new rexInteger((Integer)o);
  }
  if (o instanceof Double) { 
    return new rexDouble((Double)o);
  }
  if (o instanceof String) { 
    return new rexString((String)o);
  }
  return null;
}

rexObject translateJsonObject(JSONObject o) throws Exception {
  rexObject ret = new rexObject();
  println("keys" + o.keys());
  //for (String key: o.keys())
  //  ret.m.put(key, translateJsonSomething(o.get(key)));
  return ret;
}

rexArray translateJsonArray(JSONArray a) throws Exception {
  rexArray ret = new rexArray();
  println("translating array");
  /*for (int i = 0; i < a.length(); i++) {
    Object val = a.get(i);
    ret.a.add(translateJsonSomething(val));
  }*/
  return ret;
}

String getJsonString(rexData d) {
  try {
    Object o = getJsonD(d);
    /*if (o instanceof JSONArray)
      return ((JSONArray)o).toString(2);
    if (o instanceof JSONObject)
      return ((JSONObject)o).toString(2);*/
    return o.toString();
  } 
  catch (Exception e) { 
    handleJsonException(e);
  }
  return "";
}

Object getJsonD(rexData d) {
  if (d instanceof rexObject) { 
    return getJsonO((rexObject)d);
  }
  if (d instanceof rexArray) { 
    return getJsonA( (rexArray)d);
  }
  if (d instanceof rexString) { 
    return  ((rexString)d).s;
  }
  if (d instanceof rexInteger) { 
    return ((rexInteger)d).i;
  }
  if (d instanceof rexDouble) { 
    return  ((rexDouble)d).d;
  }
  if (d instanceof rexBoolean) { 
    return ((rexBoolean)d).b;
  }
  return null;
}

JSONObject getJsonO(rexObject o) {
  JSONObject ret = new JSONObject();
  try {
    for (String key: o.keys()) {
      //if (key != null)
      //  ret.put(key, getJsonD(o.m.get(key)));
    }
  } 
  catch (Exception e) { 
    handleJsonException(e);
  }
  return ret;
}

JSONArray getJsonA(rexArray a) {
  JSONArray ret = new JSONArray();
  //for (rexData d: a.a)
  //  ret.put(getJsonD(d));
  return ret;
}

