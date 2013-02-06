void traverseSomething(rexData o, rexNode parent) {
       if (o instanceof rexArray)  { traverseArray((rexArray)o, new rexNodeArray(parent)); }
  else if (o instanceof rexObject) { traverseHMap ((rexObject)o, new rexNodeObject(parent)); }
  else if (o instanceof rexBoolean) { new rexNodeBool  (parent, ((rexBoolean)o).b); }
  else if (o instanceof rexInteger) { new rexNodeInt   (parent, ((rexInteger)o).i); }
  else if (o instanceof rexDouble) { new rexNodeDouble(parent, ((rexDouble)o).d);  }
  else if (o instanceof rexString) { new rexNodeString(parent, ((rexString)o).s);  }
  else                             { println("iunno...."); (new rexNode(parent)).value = o; }
}

void traverseArray(rexArray a, rexNodeArray parent) {
  if (parent.parent.keyBox != null) {
    rexKey kb = parent.parent.keyBox;
    kb.namesCollection(parent);
    
    if (primariesMap.containsKey(kb.value)) {
      parent.primary = primariesMap.get(kb.value);
      kb.partialAvailable = true;
    }
  }
  for (rexData o: a.a) {
    //rexNodeArray box = new rexNodeArray(parent); // make a dummy array to contain both a label and the value
    //box.keyBox = new rexKey(box, "");           // upper box contains the label
    //traverseSomething(o, box);                   // lower box contains the object
    traverseSomething(o, parent);
  }
}

void traverseHMap(rexObject o, rexNodeObject parent) {
  String[] keys = o.m.keySet().toArray(new String[0]);
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
    traverseSomething(o.m.get(key), box);          // lower box contains the object
  }
}

int getPriority(String key) {
  if (orderingMap.containsKey(key))            return orderingMap.get(key);
  if (orderingMap.containsKey(ORDERING_OTHER)) return orderingMap.get(ORDERING_OTHER);
                                               return 0;
}

