rexNode buildSomething(rexData o) {
       if (o instanceof rexArray)   { return     buildArray     ((rexArray)o); }
  else if (o instanceof rexObject)  { return     buildHMap     ((rexObject)o); }
  else if (o instanceof rexBoolean) { return new rexNodeBool  ((rexBoolean)o); }
  else if (o instanceof rexInteger) { return new rexNodeInt   ((rexInteger)o); }
  else if (o instanceof rexDouble)  { return new rexNodeDouble ((rexDouble)o); }
  else if (o instanceof rexString)  { return new rexNodeString (((rexString)o).s); }
  else                              { rexNode generic = new rexNode(); generic.value = o; return generic; }
}

rexNodeArray buildArray(rexArray a) {
  rexNodeArray ret = new rexNodeArray();
  ret.backingData = a;

  for (rexData d: a.a) {

    rexNodeWrapper box = new rexNodeWrapper(Modes.ROW); // make a dummy array to contain both a label and a value
    ret.addChild(box);
    box.hint = "box";
    
    rexNodeKey kb = new rexNodeKey("");           // upper entry contains the label
    box.addChild(kb);
    box.keyBox = kb;
    kb.wrapper = box;
    kb.hint = "key";
    
    //rexData d = m.m.get(key);              // let data know who's displaying it
    d.keyDisplayNode   = kb;
    
    rexNode n = buildSomething(d);         // lower entry contains the value

    box.addChild(n);
    //ret.addChild(n);

  }
  ret.hint = "array";

  if (a.keyDisplayNode != null) {
    rexNodeKey kb = a.keyDisplayNode;
    kb.namesCollection(ret);
    
    String key = (String)(kb.value);
    if (primariesMap.containsKey(key)) {
      kb.collection.primary = primariesMap.get(kb.value);
      kb.partialAvailable = true;
    }
  }
  
  return ret;
}

rexNodeObject buildHMap(rexObject m) {
  rexNodeObject ret = new rexNodeObject();
  ret.backingData = m;
  
  String[] keys = m.m.keySet().toArray(new String[0]);
  String[] prioKeys = new String[keys.length];
  int i = 0;
  for (String key: keys) {
    prioKeys[i++] =String.format("%010d", getPriority(key)) + "#" + key;
  }
  prioKeys = sort(prioKeys);
      
  for (String numKey: prioKeys) {
    String key = numKey.split("#")[1];
    
    rexNodeWrapper box = new rexNodeWrapper(Modes.COLUMN); // make a dummy array to contain both a label and a value
    ret.addChild(box);
    box.hint = "box";
    
    rexNodeKey kb = new rexNodeKey(key);  // upper entry contains the label
    box.addChild(kb);
    box.keyBox = kb;
    kb.wrapper = box;
    kb.hint = "key";
    
    rexData d = m.m.get(key);             // let data know who's displaying it
    d.keyDisplayNode   = kb;
    
    rexNode n = buildSomething(d);        // lower entry contains the value
    box.addChild(n);
  }
  ret.hint = "object";
  return ret;
}

int getPriority(String key) {
  if (orderingMap.containsKey(key))            return orderingMap.get(key);
  if (orderingMap.containsKey(ORDERING_OTHER)) return orderingMap.get(ORDERING_OTHER);
                                               return 0;
}


