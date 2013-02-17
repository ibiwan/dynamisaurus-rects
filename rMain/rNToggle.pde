class rexNodeWidget extends rexNode {
  int widgetWidth = useTextSize + 4;

  rexNodeWidget() {
    super();
    min = new Sz(widgetWidth, useTextSize)
                .grow(new Sz(margin + 2, margin));
  }
}

class rexNodeToggle extends rexNodeWidget {
  rexNodeKey key = null;
  Rect expander;

  rexNodeToggle(rexNodeKey key) { 
    super();
    this.key = key;
  }

  protected void draw(Pt origin, int gray) {
    super.draw(origin, gray);

    Rect widgetBox = new Rect(contents.bounds.size().toPt(), new Sz(widgetWidth, useTextSize))
                             .move(origin)                             // place encloser on screen
                             .move(new Pt(-widgetWidth, -useTextSize)) // place widget within encloser
                             .grow(new Sz(margin));

    int squareEdge = min(widgetWidth, useTextSize);

    expander = new Rect(widgetBox.origin(), new Sz(squareEdge))
                       .move(widgetBox.size()
                            .grow(new Sz(-squareEdge))
                            .div(2)
                            .toPt());
                              
    stroke(0); noFill();
    if (key.collection != null)
      switch(key.collection.vis.v) {
        case Visibility.EXPANDED:  drawExpandedToggle (expander); break;
        case Visibility.COLLAPSED: drawCollapsedToggle(expander); break;
        case Visibility.PARTIAL:   drawPartialToggle  (expander); break;
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

void drawExpandedToggle(Rect b) {
  triangle(b.x + b.w / 4, b.y + b.h / 4,    b.x + b.w * 3 / 4, b.y + b.h     / 4,    b.x + b.w     / 2, b.y + b.h * 3 / 4);
}
void drawCollapsedToggle(Rect b) {
  triangle(b.x + b.w / 4, b.y + b.h / 4,    b.x + b.w     / 4, b.y + b.h * 3 / 4,    b.x + b.w * 3 / 4, b.y + b.h     / 2);
}
void drawPartialToggle(Rect b) {
  int dy;
  for (dy = 1; dy < b.h; dy += 3)
    line(b.x + b.w / 4,  b.y + dy,   b.x + b.w * 3/4,  b.y + dy);
  line(b.x + b.w /   4,  b.y + 1,   b.x + b.w /   4,  b.y + dy);
  line(b.x + b.w * 3/4,  b.y + 1,   b.x + b.w * 3/4,  b.y + dy);
}

