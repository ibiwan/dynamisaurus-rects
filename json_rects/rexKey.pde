class rexKey extends rexNodeString{
  int         widget_width = 20;
  boolean  namesCollection = false;
  boolean partialAvailable = false;
  rexNode       collection = null;
  Rect expander;

  rexKey(rexNode parent, String s)  { 
    super(parent, s);
    min.w += (int)textWidth(":");
  }
  
  void namesCollection(rexNode c) { 
    min.w += widget_width; 
    namesCollection = true;
    collection = c;
  }
  
  protected void draw(int x, int y, int gray) {
    super.draw((String)value + ":", x, y, gray);
    
    if (namesCollection) {
      Rect widgetBox = new Rect(x + rows.box.w - widget_width,
                                y + rows.box.h - useTextSize,
                                widget_width, useTextSize);
      
      int squareEdge = min(widget_width, useTextSize);
      Rect s = new Rect(widgetBox.x + (widgetBox.w - squareEdge) / 2,
                        widgetBox.y + (widgetBox.h - squareEdge) / 2,
                        squareEdge, squareEdge);
      expander = s;
      
      stroke(0);   noFill();
      switch(collection.vis.v) {
        case Visibility.EXPANDED:  drawExpandedWidget(s);  break;
        case Visibility.COLLAPSED: drawCollapsedWidget(s); break;
        case Visibility.PARTIAL:   drawPartialWidget(s);   break;
      }
    }
  }
  
  protected void clickReceived(Pt p) {
    if (namesCollection && expander.contains(p)) {
      switch(collection.vis.v) {
        case Visibility.EXPANDED:
          if (partialAvailable) collection.vis.v = Visibility.PARTIAL;
          else                  collection.vis.v = Visibility.COLLAPSED;
          break;
        case Visibility.COLLAPSED:  collection.vis.v = Visibility.EXPANDED;
          break;
        case Visibility.PARTIAL:    collection.vis.v = Visibility.COLLAPSED;
          break;
      }
    }
  }
}

