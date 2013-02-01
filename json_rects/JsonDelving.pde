void parseJSONUnknown(Object o, String indent, rexNode parent, JSONKey keyBox) {
       if (o instanceof JSONArray)  { parseJSONArray ((JSONArray )o, indent + " ", new rexNodeArray(parent),  keyBox); }
  else if (o instanceof JSONObject) { parseJSONObject((JSONObject)o, indent + " ", new rexNodeObject(parent), keyBox); }
  else if (o instanceof Boolean)    { parent.addChild(new rexNodeBool ((Boolean)o));                 }
  else if (o instanceof Integer)    { parent.addChild(new rexNodeInt  ((Integer)o));                 }
  else if (o instanceof Double)     { parent.addChild(new rexNodeDouble((Double)o));                 }
  else if (o instanceof String)     { parent.addChild(new rexNodeString((String)o));                 }
  else                              { (new rexNode(parent)).value = o; /*println("iunno... " + o);*/ }
}

void parseJSONArray(JSONArray a, String indent, rexNodeArray parent, JSONKey keyBox) {
  try {
    if (keyBox != null) {
      keyBox.namesCollection(parent);
      if (primariesMap.containsKey(keyBox.value)) {
        parent.primary = primariesMap.get(keyBox.value);
        println(keyBox.value + ":" + parent.primary);
        keyBox.partialAvailable = true;
      }
    }
    for (int i = 0; i < ((JSONArray)a).length(); i++) {
      Object element = ((JSONArray)a).get(i);
      parseJSONUnknown(element, indent + " ", parent, null);
    }
  }
  catch (JSONException e) { JSONExceptionDump (e); }
}

void parseJSONObject(JSONObject o, String indent, rexNodeObject parent, JSONKey keyBox) {
  try {
    if (keyBox !=  null) {
      keyBox.namesCollection(parent);
    }
    
    String[] keys = o.getNames(o);
    String[] prioKeys = new String[keys.length];

    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      int priority;
      if (orderingMap.containsKey(key)) {
        priority = orderingMap.get(key); 
      } else {
        priority = orderingMap.get("OTHER");
      }
      prioKeys[i] =String.format("%010d", priority) + "#" + key;
    }
    prioKeys = sort(prioKeys);
        
    for (int i = 0; i < prioKeys.length; i++) {
      rexNodeArray box = new rexNodeArray(parent);                // make a dummy array to contain both a label and the value
      String key = (prioKeys[i]).split("#")[1];
      JSONKey newKeyBox = new JSONKey(key);                       // upper box contains the label
      box.addChild(newKeyBox);
      parseJSONUnknown(o.get(key), indent + " ", box, newKeyBox); // lower box contains the object
    }
  }
  catch (JSONException e) { JSONExceptionDump (e); }
}

void JSONExceptionDump(JSONException e) {
  println ("There was an error parsing the JSONObject.");
  println(e.toString());
  e.printStackTrace();
}
