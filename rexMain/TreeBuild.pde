rexNode buildSomething(rexData o) {
  if (o instanceof rexArray)   { return     buildArray     ((rexArray)o); }
  if (o instanceof rexObject)  { return     buildHMap     ((rexObject)o); }
  if (o instanceof rexBoolean) { return new rexNodeBool  ((rexBoolean)o); }
  if (o instanceof rexInteger) { return new rexNodeInt   ((rexInteger)o); }
  if (o instanceof rexDouble)  { return new rexNodeDouble ((rexDouble)o); }
  if (o instanceof rexString)  { return new rexNodeString(((rexString)o).s); }
  return new rexNode(o);
}

rexNodeArray buildArray(rexArray a) {
  rexNodeArray ret = new rexNodeArray();
  ret.backingData = a;

  for (rexData d: a.a)
    ret.addChild(wrapIt(null, d, Modes.ROW));
  setupCollection(a.keyDisplayNode, ret);  

  return ret;
}

rexNodeObject buildHMap(rexObject m) {
  rexNodeObject ret = new rexNodeObject();
  ret.backingData = m;

  String[] prioKeys = getPrioritizedKeys(m.keys());
  for (String numKey: prioKeys) {
    String key = untag(numKey);  
    ret.addChild(wrapIt(key, m.m.get(key), Modes.COLUMN));
  }
  setupCollection(m.keyDisplayNode, ret);

  return ret;
}

// Processing can only sort on ints and strings, so just prepend priority to key
String   tag(String key, int priority) { return String.format("%010d", priority) + "#" + key; }
String untag(String taggedKey)         { return taggedKey.split("#")[1]; }

String[] getPrioritizedKeys(String[] keys) {
  int i = 0;
  String[] prioKeys = new String[keys.length];
  for (String key: keys)
    prioKeys[i++] = tag(key, getPriority(key));
  prioKeys = sort(prioKeys);
  return prioKeys;  
}

int getPriority(String key) {
  if (orderingMap.containsKey(key))            return orderingMap.get(key);
  if (orderingMap.containsKey(ORDERING_OTHER)) return orderingMap.get(ORDERING_OTHER);
                                               return 0;
}

rexNodeWrapper wrapIt(String key, rexData datum, int displayDirection) {
  datum = (datum != null) ? datum : new rexString("");
  rexNodeWrapper wrap = new rexNodeWrapper(displayDirection); // dummy array
  wrap.addChild(new rexNodeKey(key, wrap, datum)); // upper/left entry contains the label
  wrap.addChild(buildSomething(datum));            // lower/right entry contains the value
  return wrap;
}

void setupCollection(rexNodeKey kb, rexNode collection) {
  if (kb != null) {
    kb.namesCollection(collection);
    
    String key = (String)(kb.value);
    if (primariesMap.containsKey(key)) {
      kb.collection.primary = primariesMap.get(kb.value);
      kb.partialAvailable = true;
    }
  }
}

