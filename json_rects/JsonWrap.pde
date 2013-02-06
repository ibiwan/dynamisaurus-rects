import org.json.*;

rexObject parseJsonObject(String s) {
  try {
    return translateJsonObject(new JSONObject(s));
  } 
  catch (JSONException e) { JSONExceptionDump(e); }
  return new rexObject();
}

rexData translateJsonSomething(Object o) {
       if (o instanceof JSONArray)  { return translateJsonArray ((JSONArray) o); }
  else if (o instanceof JSONObject) { return translateJsonObject((JSONObject)o); }
  else if (o instanceof Boolean)    { return new rexBoolean((Boolean)o);    }
  else if (o instanceof Integer)    { return new rexInteger((Integer)o);    }
  else if (o instanceof Double)     { return new rexDouble((Double)o);    }
  else if (o instanceof String)     { return new rexString((String)o);    }
  else                              { return null; }
}

rexObject translateJsonObject(JSONObject o) {
  rexObject ret = new rexObject();
  try {
    for (String key: o.getNames(o)) {
      ret.put(key, translateJsonSomething(o.get(key)));
    }
  }
  catch (JSONException e) { JSONExceptionDump(e); }
  return ret;
}

rexArray translateJsonArray(JSONArray a) {
  rexArray ret = new rexArray();
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

