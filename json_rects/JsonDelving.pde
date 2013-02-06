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
  
  String[] keys = o.keySet().toArray(new String[0]);
  String[] prioKeys = new String[keys.length];
  int i = 0;
  for (String key: keys) {
    prioKeys[i++] =String.format("%010d", getPriority(key)) + "#" + key;
  }
  prioKeys = sort(prioKeys);
      
  for (String numKey: prioKeys) {
    String key = numKey.split("#")[1];
    rexNodeArray box = new rexNodeArray(parent); // make a dummy array to contain both a label and the value
    box.keyBox = new rexKey(box, key);           // upper box contains the label
    traverseSomething(o.get(key), box);          // lower box contains the object
  }
}

int getPriority(String key) {
  if (orderingMap.containsKey(key))            return orderingMap.get(key);
  if (orderingMap.containsKey(ORDERING_OTHER)) return orderingMap.get(ORDERING_OTHER);
                                               return 0;
}

