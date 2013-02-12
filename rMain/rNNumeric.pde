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
    else if (key == TAB || key == '-') {
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
  protected void saveChanges() {
    try {
      Double d = Double.valueOf(editString);
      selected.value = (d).toString();
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
      String t = editString; Double d;
      if ( (key >= '0' && key <= '9') || key == '.' ) {
        t += (char)key;
      } else if (key == DELETE) {
        t = "0";
      } else if (key == '-') {
        t = ((Double)(- Double.valueOf(t))).toString();
      } else if (key == BACKSPACE) {
        t = t.substring(0, t.length() - 1);
        if (t.equals("")) 
          t = "0";
      } else {
        return false;
      }
      d = Double.valueOf(t); // convert to trigger exception on bad chars
      editString = t;         // keep change if valid int
    } catch (NumberFormatException e) { /* do nuthin' */ }
    return true;
  }
}

