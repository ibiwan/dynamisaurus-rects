import org.json.*;

rexObject parseJsonObject(String s) {
  try {
    return translateJsonObject(new JSONObject(s));
  }
  catch (JSONException e) { 
    println ("There was an error parsing the JSONObject.");
    println(e.toString());
    e.printStackTrace();
  }
  return new rexObject();
}

rexData translateJsonSomething(Object o) throws JSONException {
  if (o instanceof JSONArray)  { return translateJsonArray ((JSONArray) o); }
  if (o instanceof JSONObject) { return translateJsonObject((JSONObject)o); }
  if (o instanceof Boolean)    { return new rexBoolean((Boolean)o); }
  if (o instanceof Integer)    { return new rexInteger((Integer)o); }
  if (o instanceof Double)     { return new rexDouble((Double)o);   }
  if (o instanceof String)     { return new rexString((String)o);   }
  return null;
}

rexObject translateJsonObject(JSONObject o) throws JSONException {
  rexObject ret = new rexObject();
  for (String key: o.getNames(o))
    ret.m.put(key, translateJsonSomething(o.get(key)));
  return ret;
}

rexArray translateJsonArray(JSONArray a) throws JSONException {
  rexArray ret = new rexArray();
    for (int i = 0; i < a.length(); i++) {
      Object val = a.get(i);
      ret.a.add(translateJsonSomething(val));
    }
    return ret;
}

