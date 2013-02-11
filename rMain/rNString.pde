void finishEditing(boolean save) {
  if(save && selected != null) 
    selected.value = editString;
  selected = null;
  editMode = false;
  editString = null;
}

class rexNodeString extends rexNode {
  boolean displayKey = true;
  boolean showCursor = true;
  int cursorToggleTimer = 0;
  rexNodeString (String s)            { super(); init(s, true); }
  rexNodeString (String s, boolean d) { super(); init(s, d);    }
  void init(String s, boolean d) {
    hint = "string";
    value = s;
    displayKey = d;
    setW(s);
  }
  protected void draw(Pt origin, int gray) {
    draw((String)value, origin, gray, "");
  }
  protected void draw(String t, Pt origin, int gray, String suffix) {
    super.draw(origin, gray);
    
    if (selected == this && editMode) {
      if (editString != null) {
        t = editString;
      } else {
        editString = t;
      }
    }
    setW(t + suffix);
    
    // unlike everything else, text is positioned by its bottom left point
    Pt textLoc = origin.plus(new Sz(margin, 0)) // left margin for bounding box
                       .plus(new Sz(0, useTextSize)) // height of text
                       .plus(new Sz(margin, margin)); // space for readability
    Sz textDim = new Sz((int)textWidth(t), -useTextSize); // up is negative
    
    if (displayKey) {
      fill(0);
      text(t + suffix, textLoc);
    }
        
    noFill(); stroke(gray);
    rect((new Rect(new Pt(margin), contents.bounds.size()))
                  .plus(origin));



    if (selected == this && editMode) {
      if (cursorToggleTimer < millis()) {
        cursorToggleTimer = millis() + 500;
        showCursor = !showCursor;
      }
      if (showCursor) {
        stroke(0);
        line(textLoc.plus(new Sz(textDim.w, margin)), new Sz(0, -margin-useTextSize));
      }
    }
  }
  protected void setW(String s) {
    int w = (s != null && displayKey == true) ? (int)textWidth(s) : 0;
    min = new Sz(w, useTextSize)
                .plus(new Sz(margin + 2, margin));
  }
  protected boolean keyReceived(int key) {
   if (editMode == false || editString == null)
      return false;
      
    if (key == ESC) {
      finishEditing(false);
      return true;
    }
    if ((key >= 'a' && key <= 'z') ||
        (key >= 'A' && key <= 'Z') ||
        (key >= '0' && key <= '9') ||
        key == '-' || key == '.' || key == ' ') {
      editString += (char)key;
      return true;
    }
    if (key == TAB || key == ENTER || key == RETURN) {
      finishEditing(true);
      return true;
    }
    if (key == DELETE) {
      editString = "";
      return true;
    }
    if (key == BACKSPACE) {
      editString = editString.substring(0, editString.length() - 1);
      return true;
    }
    return false;
  }
}

