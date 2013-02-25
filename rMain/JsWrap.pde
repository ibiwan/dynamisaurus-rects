import org.json.*;

void handleJsonException(JSONException e) {
    println ("There was an error parsing the JSONObject.");
    println(e.toString());
    e.printStackTrace();
}

rexObject parseJsonObject(String s) {
  try {
    return translateJsonObject(new org.json.JSONObject(s));
  } catch (JSONException e) { handleJsonException(e); }
  return new rexObject();
}

rexData translateJsonSomething(Object o) throws JSONException {
  if (o instanceof org.json.JSONArray)  { return translateJsonArray ((org.json.JSONArray) o); }
  if (o instanceof org.json.JSONObject) { return translateJsonObject((org.json.JSONObject)o); }
  if (o instanceof Boolean)    { return new rexBoolean((Boolean)o); }
  if (o instanceof Integer)    { return new rexInteger((Integer)o); }
  if (o instanceof Double)     { return new rexDouble((Double)o);   }
  if (o instanceof String)     { return new rexString((String)o);   }
  return null;
}

rexObject translateJsonObject(org.json.JSONObject o) throws JSONException {
  rexObject ret = new rexObject();
  String[] keys = o.getNames(o);
  if (keys == null) {
    keys = new String[0];
  }
  for (String key: keys)
    ret.m.put(key, translateJsonSomething(o.get(key)));
  return ret;
}

rexArray translateJsonArray(org.json.JSONArray a) throws JSONException {
  rexArray ret = new rexArray();
    for (int i = 0; i < a.length(); i++) {
      Object val = a.get(i);
      ret.a.add(translateJsonSomething(val));
    }
    return ret;
}

String getJsonString(rexData d) {
  try {
    Object o = getJsonD(d);
    if (o instanceof org.json.JSONArray)
      return ((org.json.JSONArray)o).toString(2);
    if (o instanceof org.json.JSONObject)
      return ((org.json.JSONObject)o).toString(2);
    return o.toString();
  } catch (JSONException e) { handleJsonException(e); }
  return "";
}

Object getJsonD(rexData d) {
  if (d instanceof rexObject)  { return getJsonO((rexObject)d); }
  if (d instanceof rexArray)   { return getJsonA( (rexArray)d); }
  if (d instanceof rexString)  { return  ((rexString)d).s; }
  if (d instanceof rexInteger) { return ((rexInteger)d).i; }
  if (d instanceof rexDouble)  { return  ((rexDouble)d).d; }
  if (d instanceof rexBoolean) { return ((rexBoolean)d).b; }
  return null;
}

org.json.JSONObject getJsonO(rexObject o) {
  org.json.JSONObject ret = new org.json.JSONObject();
  try {
    for (String key: o.keys()) {
      if (key != null)
        ret.put(key, getJsonD(o.m.get(key)));
    }
  } catch (JSONException e) { handleJsonException(e); }
  return ret;
}

org.json.JSONArray getJsonA(rexArray a) {
  org.json.JSONArray ret = new org.json.JSONArray();
  for (rexData d: a.a)
    ret.put(getJsonD(d));
  return ret;
}

