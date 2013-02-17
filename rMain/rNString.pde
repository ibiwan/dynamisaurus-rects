HashMap<Character, Boolean> stringKeys;

class rexNodeString extends rexNode {
  boolean displayKey = true;
  boolean showCursor = true;
  int cursorToggleTimer = 0;
  rexString backingData;
  rexNodeString (rexString rs)                      { super(); init(rs, rs.s, true); }
  rexNodeString (rexString rs, String s)            { super(); init(rs, rs.s, true); }
  rexNodeString (rexString rs, String s, boolean d) { super(); init(rs, rs.s, d);    }
  rexNodeString (String s, boolean d)               { super(); init(null,  s, d);    }
  rexNodeString (String s)                          { super(); init(null,  s, true);    }
  void init(rexString rs, String s, boolean d) {
    value = s;
    displayKey = d;
    setW(s);
    editable = true;
    if (rs != null)
      backingData = rs;
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
    Pt textLoc = origin.move(new Sz(margin, 0))           // left margin for bounding box
                       .move(new Sz(margin, margin));     // space for readability
    Sz textDim = new Sz((int)textWidth(t), useTextSize);
    
    if (displayKey) {
      fill(0);
      saneText(t + suffix, textLoc);
    }
        
    noFill(); stroke(gray);
    rect((new Rect(new Pt(margin), contents.bounds.size()))
                  .move(origin));

    if (selected == this && editMode) {
      if (cursorToggleTimer < millis()) {
        cursorToggleTimer = millis() + 500;
        showCursor = !showCursor;
      }
      if (showCursor) {
        stroke(0);
        line(textLoc.move(new Sz(textDim.w, margin)), new Sz(0, useTextSize - margin));
      }
    }
  }
  protected void setW(String s) {
    int w = (s != null && displayKey == true) ? (int)textWidth(s) : 0;
    min = new Sz(w, useTextSize)
                .grow(new Sz(margin + 2, margin));
  }
  protected boolean keyReceived(int key) {
    if (editMode == false || editString == null)
      return false;
    if (key == ESC) {
      finishEditing(false);
    } else if (stringKeys.containsKey(new Character((char)key))) {
      editString += (char)key;
    } else if (key == TAB || key == ENTER || key == RETURN) {
      finishEditing(true);
    } else if (key == DELETE) {
      editString = "";
    } else if (key == BACKSPACE) {
      editString = editString.substring(0, editString.length() - 1);
    } else {
      return false;
    }
    return true;
  }
  protected void saveChanges() { 
    selected.value = editString; 
    if (backingData != null) {
      backingData.s = editString;
      saveFile();
    }
  }
}

void setupStringKeys() {
  stringKeys = new HashMap<Character, Boolean>();
  for(char c = 'a'; c <= 'z'; c++)
    stringKeys.put(c, true);
  for(char c = 'A'; c <= 'Z'; c++)
    stringKeys.put(c, true);
  for(char c = '0'; c <= '9'; c++)
    stringKeys.put(c, true);
  for(char c: new char[]{'=', '-', '.', ' ', '[', ']', '(', ')'})
    stringKeys.put(c, true);
}

