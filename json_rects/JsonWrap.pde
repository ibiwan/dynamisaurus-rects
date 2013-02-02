import org.json.*;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

HashMap<String, Object> parseJsonObject(String s) {
  HashMap<String, Object> ret = new HashMap<String, Object>();
  try {
    ret = translateJsonObject(new JSONObject(s));
  } 
  catch (JSONException e) { JSONExceptionDump(e); }
  finally { return ret; }
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
    String[] keys = o.getNames(o);
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      Object tVal = translateJsonSomething(o.get(key));
      ret.put(key, tVal);
    }
  }
  catch (JSONException e) { JSONExceptionDump(e); }
  finally { return ret; }
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
  finally { return ret; }
}

void JSONExceptionDump(JSONException e) {
  println ("There was an error parsing the JSONObject.");
  println(e.toString());
  e.printStackTrace();
}
