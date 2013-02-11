class rexNodeToggle extends rexNode {
  int widgetWidth = useTextSize + 4;
  rexNodeKey  key = null;
  Rect expander;

  rexNodeToggle(rexNodeKey k) { 
    super();
    hint = "toggle";
    key = k;
    min = new Sz(widgetWidth, useTextSize)
                .plus(new Sz(margin));
  }

  protected void draw(Pt origin, int gray) {
    super.draw(origin, gray);
    Rect widgetBox = new Rect(contents.bounds.size().toPt(), new Sz(widgetWidth, useTextSize))
      .plus(origin)                             // place encloser on screen
      .minus(new Pt(widgetWidth, useTextSize)) // place widget within encloser
      .plus(new Sz(margin));

    int squareEdge = min(widgetWidth, useTextSize);
    expander = new Rect(widgetBox.origin(), new Sz(squareEdge))
                       .plus(widgetBox.size()
                            .toPt()
                            .minus(new Sz(squareEdge))
                            .div(2));
    //fill(255); rect(widgetBox);
    //fill(0); rect(expander);
                              
    stroke(0); noFill();
    if (key.collection != null)
      switch(key.collection.vis.v) {
        case Visibility.EXPANDED:  drawExpandedWidget (expander); break;
        case Visibility.COLLAPSED: drawCollapsedWidget(expander); break;
        case Visibility.PARTIAL:   drawPartialWidget  (expander); break;
      }
  }

  protected void clickReceived(Pt p) {
    super.clickReceived(p);
    if (key.collection != null && expander.contains(p)) {
      switch(key.collection.vis.v) {
        case Visibility.EXPANDED:
          if (key.partialAvailable) key.collection.vis.v = Visibility.PARTIAL;
          else                      key.collection.vis.v = Visibility.COLLAPSED; break;
        case Visibility.PARTIAL:    key.collection.vis.v = Visibility.COLLAPSED; break;
        case Visibility.COLLAPSED:  key.collection.vis.v = Visibility.EXPANDED;  break;
      }
    }
  }
}

