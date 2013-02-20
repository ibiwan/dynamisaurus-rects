rexNode buildSomething(rexData o, String lastKey) {
  if (o instanceof rexArray)   { return     buildArray     ((rexArray)o, lastKey); }
  if (o instanceof rexObject)  { return     buildHMap     ((rexObject)o); }
  if (o instanceof rexBoolean) { return new rexNodeBool  ((rexBoolean)o); }
  if (o instanceof rexInteger) { return new rexNodeInt   ((rexInteger)o); }
  if (o instanceof rexDouble)  { return new rexNodeDouble ((rexDouble)o); }
  if (o instanceof rexString)  { return new rexNodeString(((rexString)o)); }
  return new rexNode(o);
}

rexNodeArray buildArray(rexArray a, String lastKey) {
  rexNodeArray ret = new rexNodeArray();
  ret.backingData = a;

  for (rexData d: a.a)
    ret.addChild(wrapElement(lastKey, d));
  setupCollection(a.keyDisplayNode, ret);  

  return ret;
}

rexNodeObject buildHMap(rexObject m) {
  rexNodeObject ret = new rexNodeObject();
  ret.backingData = m;

  String[] prioKeys = getPrioritizedKeys(m.keys());
  for (String numKey: prioKeys) {
    String key = untag(numKey);  
    ret.addChild(wrapMember(key, m.m.get(key), m));
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

rexNodeWrapper wrapElement(String key, rexData datum) {
  datum = (datum != null) ? datum : new rexString("");
  rexNodeWrapper full = new rexNodeWrapper(Modes.ROW);  // dummy array
  rexNodeKey k = new rexNodeKey(key, full, datum, false);
  rexNodeContextMenuIcon menu = new rexNodeContextMenuIcon(k);
  
  rexNodeWrapper widgetBar = new rexNodeWrapper(Modes.COLUMN);
  widgetBar.addChild(new rexNodeToggle(k)); 
  widgetBar.addChild(k); // left entry contains the label
  widgetBar.addChild(menu); // left entry contains the label
  
  full.addChild(widgetBar);
  full.addChild(buildSomething(datum, key));                   // right entry contains the value
  return full;
}

rexNodeWrapper wrapMember(String key, rexData datum, rexObject container) {
  datum = (datum != null) ? datum : new rexString("");
  rexNodeWrapper wrap = new rexNodeWrapper(Modes.COLUMN);  // dummy array
  rexNodeKey k = new rexNodeKey(key, wrap, datum, true); 
  k.backingKey = key;
  k.backingObject = container;
  // upper entry contains the label
  if (primariesMap.containsKey(key)) {
    // if it's a known collection, include expander widget
    rexNodeWrapper w2 = new rexNodeWrapper(Modes.ROW);
    
    w2.addChild(k);   
    w2.addChild(new rexNodeToggle(k));
    wrap.addChild(w2);
  } else {
    wrap.addChild(k);
  }
  wrap.addChild(buildSomething(datum, key));    // lower entry contains the value
  return wrap;
}

void setupCollection(rexNodeKey kb, rexNode collection) {
  if (kb != null) {
    kb.namesCollection(collection);
    
    String key = (String)(kb.value);
    if (primariesMap.containsKey(key)) {
      kb.collection.primary = primariesMap.get(key);
      kb.partialAvailable = true;
    }
  }
}

