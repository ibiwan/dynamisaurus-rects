import org.json.*;

HashMap<String, Object> parseJsonObject(String s) {
  try {
    return translateJsonObject(new JSONObject(s));
  } 
  catch (JSONException e) { JSONExceptionDump(e); }
  return new HashMap<String, Object>();
}

Object translateJsonSomething(Object o) {
       if (o instanceof JSONArray)  { return translateJsonArray ((JSONArray) o); }
  else if (o instanceof JSONObject) { return translateJsonObject((JSONObject)o); }
  else if (o instanceof Boolean)    { return o;    }
  else if (o instanceof Integer)    { return o;    }
  else if (o instanceof Double)     { return o;    }
  else if (o instanceof String)     { return o;    }
  else                              { return null; }
}

HashMap<String, Object> translateJsonObject(JSONObject o) {
  HashMap<String, Object> ret = new HashMap<String, Object>();
  try {
    for (String key: o.getNames(o)) {
      ret.put(key, translateJsonSomething(o.get(key)));
    }
  }
  catch (JSONException e) { JSONExceptionDump(e); }
  return ret;
}

ArrayList translateJsonArray(JSONArray a) {
  ArrayList ret = new ArrayList();
  try {
    for (int i = 0; i < a.length(); i++) {
      Object val = a.get(i);
      ret.add(translateJsonSomething(val));
    }
  }
  catch (JSONException e) { JSONExceptionDump(e); }
  return ret;
}

void JSONExceptionDump(JSONException e) {
  println ("There was an error parsing the JSONObject.");
  println(e.toString());
  e.printStackTrace();
}

