void traverseJsonSomething(Object o, String indent, rexNode parent, JSONKey keyBox) {
       if (o instanceof ArrayList)  { traverseJsonArray ((ArrayList )o, indent + " ", new rexNodeArray(parent),  keyBox); }
  else if (o instanceof HashMap)    { traverseJsonObject((HashMap)o, indent + " ", new rexNodeObject(parent), keyBox); }
  else if (o instanceof Boolean)    { parent.addChild(new rexNodeBool ((Boolean)o));                 }
  else if (o instanceof Integer)    { parent.addChild(new rexNodeInt  ((Integer)o));                 }
  else if (o instanceof Double)     { parent.addChild(new rexNodeDouble((Double)o));                 }
  else if (o instanceof String)     { parent.addChild(new rexNodeString((String)o));                 }
  else                              { (new rexNode(parent)).value = o; /*println("iunno... " + o);*/ }
}

void traverseJsonArray(ArrayList a, String indent, rexNodeArray parent, JSONKey keyBox) {
  if (keyBox != null) {
    keyBox.namesCollection(parent);
    if (primariesMap.containsKey(keyBox.value)) {
      parent.primary = primariesMap.get(keyBox.value);
      println(keyBox.value + ":" + parent.primary);
      keyBox.partialAvailable = true;
    }
  }
  for (int i = 0; i < a.size(); i++) {
    Object element = a.get(i);
    traverseJsonSomething(element, indent + " ", parent, null);
  }
}

void traverseJsonObject(HashMap<String, Object> o, String indent, rexNodeObject parent, JSONKey keyBox) {
  if (keyBox !=  null) {
    keyBox.namesCollection(parent);
  }
  
  String[] keys = {};
  keys = o.keySet().toArray(keys);
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
    traverseJsonSomething(o.get(key), indent + " ", box, newKeyBox); // lower box contains the object
  }
}

