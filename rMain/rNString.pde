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
    draw((String)value, origin, gray);
  }
  protected void draw(String t, Pt origin, int gray) {
    super.draw(origin, gray);
    
    if (selected == this && editMode) {
      if (editString != null) {
        t = editString;
      } else {
        editString = t + "*";
      }
    }
    setW(t);
    
    Pt textLoc = origin.plus(new Sz(2 * margin, margin + useTextSize));
    Sz textDim = new Sz((int)textWidth(t), -useTextSize);
    
    if (displayKey) {
      fill(0);
      text(t, textLoc);
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
                .plus(new Sz(margin));
  }
}

