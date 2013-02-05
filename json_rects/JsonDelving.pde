void traverseSomething(Object o, String indent, rexNode parent, rexKey keyBox) {
       if (o instanceof ArrayList)  { traverseArray((ArrayList)o, indent + " ", new rexNodeArray(parent),  keyBox); }
  else if (o instanceof HashMap)    { traverseHMap ((HashMap)  o, indent + " ", new rexNodeObject(parent), keyBox); }
  else if (o instanceof Boolean)    { parent.addChild(new rexNodeBool ((Boolean)o));                 }
  else if (o instanceof Integer)    { parent.addChild(new rexNodeInt  ((Integer)o));                 }
  else if (o instanceof Double)     { parent.addChild(new rexNodeDouble((Double)o));                 }
  else if (o instanceof String)     { parent.addChild(new rexNodeString((String)o));                 }
  else                              { (new rexNode(parent)).value = o; /*println("iunno... " + o);*/ }
}

void traverseArray(ArrayList a, String indent, rexNodeArray parent, rexKey keyBox) {
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
    traverseSomething(element, indent + " ", parent, null);
  }
}

void traverseHMap(HashMap<String, Object> o, String indent, rexNodeObject parent, rexKey keyBox) {
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
    } else if (orderingMap.containsKey(ORDERING_OTHER)) {
      priority = orderingMap.get(ORDERING_OTHER);
    } else {
      priority = 0;
    }
    prioKeys[i] =String.format("%010d", priority) + "#" + key;
  }
  prioKeys = sort(prioKeys);
      
  for (int i = 0; i < prioKeys.length; i++) {
    rexNodeArray box = new rexNodeArray(parent);                 // make a dummy array to contain both a label and the value
    String key = (prioKeys[i]).split("#")[1];
    rexKey newKeyBox = new rexKey(key);                          // upper box contains the label
    box.addChild(newKeyBox);
    traverseSomething(o.get(key), indent + " ", box, newKeyBox); // lower box contains the object
  }
}

