class rexNodeKey extends rexNodeString {
  int          widgetWidth = useTextSize + 4;
  boolean partialAvailable = false;
  rexNode       collection = null;
  rexNode          wrapper = null;
  Rect expander;
  rexObject backingObject;
  String backingKey;

  rexNodeKey(String s, rexNode w, rexData datum, boolean d) {
    super(s, d);
    if (displayKey == true && s != null)
      min.w += (int)textWidth(":");
    wrapper = w;
    datum.keyDisplayNode = this;
    arrangement = new Modes(Modes.ROW);
  }

  void namesCollection(rexNode c) { 
    collection = c;
    setW((String)value);
  }

  protected void draw(Pt origin, int gray) {
    String v = (String)value;
    String disp = (value == null || displayKey == false) ? "" : v;
    super.draw(disp, origin, gray, ":");
  }

  protected void clickReceived(Pt p) {
    super.clickReceived(p);
    if (collection != null && expander != null && expander.contains(p)) {
      switch(collection.vis.v) {
        case Visibility.EXPANDED:
          if (partialAvailable)     collection.vis.v = Visibility.PARTIAL;
          else                      collection.vis.v = Visibility.COLLAPSED; break;
        case Visibility.PARTIAL:    collection.vis.v = Visibility.COLLAPSED; break;
        case Visibility.COLLAPSED:  collection.vis.v = Visibility.EXPANDED;  break;
      }
    }
  }
  protected void setW(String s) {
    if (s != null && displayKey == true) {
      min = new Sz((int)textWidth(s), useTextSize).grow(new Sz(margin + 2, margin));
    } else {
      min = new Sz(10, 10);
      vis = new Visibility(Visibility.NONE);
    }
  }
  protected void saveChanges() { 
    value = editString; 
    if (backingKey != null) {
      rexData value = backingObject.m.get(backingKey);
      backingObject.m.remove(backingKey);
      backingKey = editString;
      backingObject.m.put(backingKey, value);
      saveFile();
    } else {
      println("no key :(");
    }
  }
}

