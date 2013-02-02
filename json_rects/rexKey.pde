class rexKey extends rexNodeString{
  int         widget_width = 20;
  boolean  namesCollection = false;
  boolean partialAvailable = false;
  rexNode       collection = null;
  Rect expander;

  rexKey(String s)  { 
    super(s); 
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
      Rect widgetBox = new Rect(x + cur.w - widget_width,
                                y + cur.h - useTextSize,
                                widget_width, useTextSize);
      
      int squareEdge = min(widget_width, useTextSize);
      Rect s = new Rect(widgetBox.x + (widgetBox.w - squareEdge) / 2,
                        widgetBox.y + (widgetBox.h - squareEdge) / 2,
                        squareEdge, squareEdge);
      expander = s;
      
      stroke(0);   noFill();
      switch(collection.state.s) {
        case States.EXPANDED:  drawExpandedWidget(s);  break;
        case States.COLLAPSED: drawCollapsedWidget(s); break;
        case States.PARTIAL:   drawPartialWidget(s);   break;
      }
    }
  }
  
  protected void clickReceived(Pt p) {
    if (namesCollection && expander.contains(p)) {
      switch(collection.state.s) {
        case States.EXPANDED:
          if (partialAvailable) collection.state.s = States.PARTIAL;
          else                  collection.state.s = States.COLLAPSED;
          break;
        case States.COLLAPSED:  collection.state.s = States.EXPANDED;
          break;
        case States.PARTIAL:    collection.state.s = States.COLLAPSED;
          break;
      }
    }
  }
}
