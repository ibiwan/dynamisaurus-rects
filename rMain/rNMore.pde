class rexNodeObject extends rexNode {
  rexObject backingData;
  rexNodeObject() { 
    super(); 
    hint = "object";
  }

  protected ArrayList<String> getSummaries() {
    int i = 0;
    ArrayList<String> ret = new ArrayList<String>();
    if (backingData.m.containsKey(primary)) {
      ret.add (((rexString)backingData.m.get(primary)).s);
    }
    return ret;
  }
}

class rexNodeArray extends rexNode {
  rexArray backingData;
  rexNodeArray () { 
    super(); 
    hint = "array";
    arrangement.m = Modes.COLUMN;
  }
  protected ArrayList<String> getSummaries() {
    int i = 0; 
    String use_str;
    ArrayList<String> ret = new ArrayList<String>();
    for (rexData d: backingData.a) {
      if (d instanceof rexObject) { // for each array child, look for its "display" field
        use_str = "" + i++;
        if (((rexObject)d).m.containsKey(primary)) {
          rexData value = ((rexObject)d).m.get(primary);
          if (value instanceof rexString) { // <<FIXME>> handle other data types too
            use_str = ((rexString)value).s;
            ret.add(use_str);
          }
        }
      }
    }
    return ret;
  }
}

class rexNodeWrapper extends rexNodeArray {
  rexNodeWrapper(int m) { 
    super(); 
    hint = "wrapper"; 
    arrangement.m = m;
  }
}

class rexNodeBool extends rexNodeString { 
  rexNodeBool  (rexBoolean b) { 
    super(b.b.toString()); 
    hint = "bool";
  }   
  protected void draw(Pt origin, int gray) {
    textFont(italicFont);
    super.draw(origin, gray);
    textFont(normalFont);
  }

  protected boolean keyReceived(int key) {
    if (editMode == false || editString == null)
      return false;

    if (key == ESC) {
      finishEditing(false); // cancel edit
    } 
    else  if (key == 't' || key == 'T') {
      editString = "true";
    } 
    else if (key == 'f' || key == 'F' || key == DELETE || key == BACKSPACE) {
      editString = "false";
    } 
    else if (key == TAB) {
      editString = (editString.equals("true")) ? "false" : "true";
    } 
    else if (key == ENTER || key == RETURN) {
      finishEditing(true); // save edit
    } 
    else {
      return false;
    }
    return true;
  }
}

class rexNodeInt    extends rexNodeString { 
  rexNodeInt   (rexInteger i) { 
    super(i.i.toString()); 
    hint = "int";
  } 
  protected void draw(Pt origin, int gray) {
    textFont(monospFont);
    super.draw(origin, gray);
    textFont(normalFont);
  }
  protected void saveChanges() {
    try {
      Integer i = Integer.valueOf(editString);
      selected.value = (i).toString();
    } catch (NumberFormatException e) {
      // do nuthin'
    }
  }
  protected boolean keyReceived(int key) {
    if (key == ESC || key == TAB || key == ENTER || key == RETURN)
      return super.keyReceived(key);
    if (editMode == false || editString == null)
      return false;      
 
    try {
      String t = editString; Integer i;
      if ( key >= '0' && key <= '9' ) {
        t += (char)key;
      } else if (key == DELETE) {
        t = "0";
      } else if (key == '-') {
        t = ((Integer)(- Integer.valueOf(t))).toString();
      } else if (key == BACKSPACE) {
        t = t.substring(0, t.length() - 1);
        if (t.equals("")) 
          t = "0";
      } else {
        return false;
      }
      i = Integer.valueOf(t); // convert to trigger exception on bad chars
      editString = t;         // keep change if valid int
    } catch (NumberFormatException e) { /* do nuthin' */ }
    return true;
  }
}

class rexNodeDouble extends rexNodeString { 
  rexNodeDouble(rexDouble  d) { 
    super(d.d.toString()); 
    hint = "double";
  } 
  protected void draw(Pt origin, int gray) {
    textFont(monospFont);
    super.draw(origin, gray);
    textFont(normalFont);
  }
}

