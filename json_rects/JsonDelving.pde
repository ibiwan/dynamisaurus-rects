void traverseSomething(Object o, rexNode parent) {
       if (o instanceof ArrayList) { traverseArray((ArrayList)o, new rexNodeArray(parent)); }
  else if (o instanceof HashMap)   { traverseHMap ((HashMap)  o, new rexNodeObject(parent)); }
  else if (o instanceof Boolean)   { new rexNodeBool (parent, (Boolean)o); }
  else if (o instanceof Integer)   { new rexNodeInt  (parent, (Integer)o); }
  else if (o instanceof Double)    { new rexNodeDouble(parent, (Double)o); }
  else if (o instanceof String)    { new rexNodeString(parent, (String)o); }
  else                             { (new rexNode(parent)).value = o; }
}

void traverseArray(ArrayList a, rexNodeArray parent) {
  if (parent.parent.keyBox != null) {
    rexKey kb = parent.parent.keyBox;
    kb.namesCollection(parent);
    if (primariesMap.containsKey(kb.value)) {
      parent.primary = primariesMap.get(kb.value);
      println(kb.value + ":" + parent.primary);
      kb.partialAvailable = true;
    }
  }
  for (int i = 0; i < a.size(); i++) {
    Object element = a.get(i);
    traverseSomething(element, parent);
  }
}

void traverseHMap(HashMap<String, Object> o, rexNodeObject parent) {
  if (parent.parent.keyBox !=  null) {
    parent.parent.keyBox.namesCollection(parent);
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
      
  for (String numKey: prioKeys) {
    rexNodeArray box = new rexNodeArray(parent); // make a dummy array to contain both a label and the value
    String key = numKey.split("#")[1];
    rexKey kb = new rexKey(box, key);
    box.keyBox = kb;           // upper box contains the label
    traverseSomething(o.get(key), box);          // lower box contains the object
  }
}

