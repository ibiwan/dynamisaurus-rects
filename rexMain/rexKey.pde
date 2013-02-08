class rexNodeKey extends rexNodeString{
  int         widget_width = 20;
  boolean partialAvailable = false;
  rexNode       collection = null;
  rexNode          wrapper = null;
  Rect expander;

  rexNodeKey(String s)  { 
    super(s);
    hint = "key";
    if (s != null)
      min.w += (int)textWidth(":");
  }
  
  void namesCollection(rexNode c) { 
    min.w += widget_width; 
    collection = c;
  }
  
  protected void draw(Pt origin, int gray) {
    String disp = (value == null) ? "" : (String)value + ":";
    super.draw(disp, origin, gray);
    
    if (collection != null) {
      // place widget space using bottom right of container
      Rect widgetBox = new Rect(contents.bounds.size().toPt(), 0, 0)
                               .plus(new Sz(widget_width, useTextSize))
                               .minus(new Pt(widget_width, useTextSize))
                               .plus(origin);
      
      int squareEdge = min(widget_width, useTextSize);
      expander = new Rect(widgetBox.origin(), new Sz(squareEdge))
                         .plus(widgetBox.size()
                                        .toPt()
                                        .minus(new Pt(squareEdge))
                                        .div(2));
      
      stroke(0);   noFill();
      switch(collection.vis.v) {
        case Visibility.EXPANDED:  drawExpandedWidget (expander);  break;
        case Visibility.COLLAPSED: drawCollapsedWidget(expander); break;
        case Visibility.PARTIAL:   drawPartialWidget  (expander);   break;
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
}

