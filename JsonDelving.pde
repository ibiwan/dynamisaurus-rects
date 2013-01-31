import java.util.Arrays;

void parseJSONUnknown(Object o, String indent, JSONode parent, JSONKey keyBox) {
       if (o.getClass().equals( JSONArray.class)) { parseJSONArray ((JSONArray )o, indent + " ", new JSONodeArray(parent),  keyBox); }
  else if (o.getClass().equals(JSONObject.class)) { parseJSONObject((JSONObject)o, indent + " ", new JSONodeObject(parent), keyBox); }
  else if (o.getClass().equals(   Boolean.class)) { parent.addChild(new JSONodeBool ((Boolean)o));                 }
  else if (o.getClass().equals(   Integer.class)) { parent.addChild(new JSONodeInt  ((Integer)o));                 }
  else if (o.getClass().equals(    Double.class)) { parent.addChild(new JSONodeDouble((Double)o));                 }
  else if (o.getClass().equals(    String.class)) { parent.addChild(new JSONodeString((String)o));                 }
  else                                            { (new JSONode(parent)).value = o; /*println("iunno... " + o);*/ }
}

void parseJSONArray(JSONArray a, String indent, JSONodeArray parent, JSONKey keyBox) {
  try {
    if (keyBox != null) {
      keyBox.namesCollection(parent);
      //println(keyBox.value);
      if (primariesMap.containsKey(keyBox.value)) {
        parent.primary = (String)primariesMap.get(keyBox.value);
        println(keyBox.value + ":" + parent.primary);
        keyBox.partialAvailable = true;
      }
    }
    for (int i = 0; i < ((JSONArray)a).length(); i++) {
      Object element = ((JSONArray)a).get(i);
      parseJSONUnknown(element, indent + " ", parent, null);
    }
  }
  catch (JSONException e) {
    println ("There was an error parsing the JSONArray.");
    println(e.toString());
  };
}

void parseJSONObject(JSONObject o, String indent, JSONodeObject parent, JSONKey keyBox) {
  try {
    if (keyBox !=  null) {
      keyBox.namesCollection(parent);
      //println(keyBox.value);
    }
    
    String[] keys = o.getNames(o);
    
    IndexedObject[] ordering = {};
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      int priority;
      if (orderingMap.containsKey(key)) {
        priority = (Integer)orderingMap.get(key); 
      } else {
        priority = (Integer)orderingMap.get("OTHER");
      }
      IndexedObject io = new IndexedObject(priority, key);
      ordering = (IndexedObject[])append(ordering, io);
    }
    Arrays.sort(ordering);
    
    for (int i = 0; i < ordering.length; i++) {
      JSONodeArray box = new JSONodeArray(parent); // make a dummy array to contain both a label and the value
      String key = (String)ordering[i].object;     
      //println(key);
      JSONKey newKeyBox = new JSONKey(key);        // upper box contains the label
      box.addChild(newKeyBox);
      parseJSONUnknown(o.get(key), indent + " ", box, newKeyBox); // lower box contains the object
    }
  }
  catch (JSONException e) {
    println ("There was an error parsing the JSONObject.");
    println(e.toString());
  };
}

