class rexNodeKey extends rexNodeString {
  int          widgetWidth = useTextSize + 4;
  boolean partialAvailable = false;
  rexNode       collection = null;
  rexNode          wrapper = null;
  Rect expander;

  rexNodeKey(String s, rexNode w, rexData datum, boolean d) { 
    super(s, d);
    hint = "key";
    if (displayKey == true && s != null)
      min.w += (int)textWidth(":");
    wrapper = w;
    datum.keyDisplayNode = this;
  }

  void namesCollection(rexNode c) { 
    collection = c;
    setW((String)value);
  }

  protected void draw(Pt origin, int gray) {
    String disp = (value == null || displayKey == false) ? "" : (String)value + ":";
    super.draw(disp, origin, gray);

    if (collection != null) {
      // place widget space using bottom right of container
      Rect widgetBox = new Rect(contents.bounds.size().toPt(), new Sz(widgetWidth, useTextSize))
        .plus(origin)                             // place encloser
        .minus(new Pt(widgetWidth, useTextSize)); // place within encloser

      int squareEdge = min(widgetWidth, useTextSize);
      expander = new Rect(widgetBox.origin(), new Sz(squareEdge))
                         .plus(widgetBox.size()
                              .toPt()
                              .minus(new Sz(squareEdge))
                              .div(2));

      stroke(0); noFill();
      switch(collection.vis.v) {
        case Visibility.EXPANDED:  drawExpandedWidget (expander); break;
        case Visibility.COLLAPSED: drawCollapsedWidget(expander); break;
        case Visibility.PARTIAL:   drawPartialWidget  (expander); break;
      }
    }
  }

  protected void clickReceived(Pt p) {
    super.clickReceived(p);
    if (collection != null && expander.contains(p)) {
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
    int w = (s != null && displayKey == true) ? (int)textWidth(s) : 0;
    if (collection != null)
      w += widgetWidth + margin;
    min = new Sz(w, useTextSize)
                .plus(new Sz(margin));
  }
}

