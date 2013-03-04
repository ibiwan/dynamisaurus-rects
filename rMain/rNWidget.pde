class rexNodeWidget extends rexNode {
  rexNodeKey key = null;
  int widgetWidth = useTextSize + 4;
  Rect clickBounds;

  rexNodeWidget(rexNodeKey key) {
    super();
    this.key = key;
    min = new Sz(widgetWidth, useTextSize)
                .grow(new Sz(margin + 2, margin));
  }

  protected void draw(Pt origin, int gray) {
    super.draw(origin, gray);

    Rect widgetBox = new Rect(contents.bounds.size().toPt(), new Sz(widgetWidth, useTextSize))
                             .move(origin)                             // place encloser on screen
                             .move(new Pt(-widgetWidth, -useTextSize)) // place widget within encloser
                             .grow(new Sz(margin));

    int squareEdge = min(widgetWidth, useTextSize);

    clickBounds = new Rect(widgetBox.origin(), new Sz(squareEdge))
                          .move(widgetBox.size()
                               .grow(new Sz(-squareEdge))
                               .div(2)
                               .toPt());
  }
}

class rexNodeContextMenuIcon extends rexNodeWidget {
  rexNodeContextMenu menu = new rexNodeContextMenu();
  Pt lastLoc = new Pt();

  rexNodeContextMenuIcon(rexNodeKey key) { 
    super(key);
    this.arrangement = new Modes(Modes.COLUMN);
//    addMenuItem(new rexNodeContextMenuItem("x"));
//    addMenuItem(new rexNodeContextMenuItem("y"));
//    addMenuItem(new rexNodeContextMenuItem("z"));
  }  

  void addChild(rexNode node) {
    // do nothing; this should use addMenuItem
  }
  
  void addMenuItem(rexNodeContextMenuItem mi) {
    menu.addChild(mi);
    vis = new Visibility(Visibility.EXPANDED);
  }
  
  protected boolean arrange(int parent_maxw) {
    menu.iconLoc = lastLoc;
    vis = key.collection.vis;
    if (vis.v == Visibility.PARTIAL) {
      vis = new Visibility(Visibility.COLLAPSED);
    }
    return super.arrange(parent_maxw);
  }

  protected void draw(Pt origin, int gray) {
    lastLoc = origin;
    if (menu.childCount() > 0) {
      super.draw(origin, gray);
  
      stroke(0); noFill();
      if (key.collection.vis.v == Visibility.EXPANDED)
        drawContextMenuIcon(clickBounds);
    }
  }
  protected void clickReceived(Pt p) {
    super.clickReceived(p);
    if (clickBounds.contains(p)) {
      println("menu clicked");
      popUp = menu;
    }
  }
  protected ArrayList<String> getSummaries() { return new ArrayList<String>(); }
}

void drawContextMenuIcon(Rect b) {
  rect(b);
  for (int dy = 2; dy < min(3, b.h); dy+=2) line(b.x,            b.y + dy,    b.x + b.w,          b.y + dy);
  for (int dy = 4; dy < b.h - 1; dy += 2)   line(b.x + b.w / 4,  b.y + dy,    b.x + b.w * 3 / 4,  b.y + dy);
}

class rexNodeToggle extends rexNodeWidget {
  rexNodeToggle(rexNodeKey key) {
    super(key);
  }
  protected void draw(Pt origin, int gray) {
    super.draw(origin, gray);

    stroke(0); noFill();
    if (key.collection != null)
      switch(key.collection.vis.v) {
        case Visibility.EXPANDED:  drawExpandedToggle (clickBounds); break;
        case Visibility.COLLAPSED: drawCollapsedToggle(clickBounds); break;
        case Visibility.PARTIAL:   drawPartialToggle  (clickBounds); break;
      }
  }

  protected void clickReceived(Pt p) {
    super.clickReceived(p);
    if (key.collection != null && clickBounds.contains(p)) {
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
  triangle(b.x + b.w / 4, b.y + b.h / 4,    b.x + b.w * 3 / 4, b.y + b.h / 4,    b.x + b.w / 2, b.y + b.h * 3 / 4);
}
void drawCollapsedToggle(Rect b) {
  triangle(b.x + b.w / 4, b.y + b.h / 4,    b.x + b.w / 4, b.y + b.h * 3 / 4,    b.x + b.w * 3 / 4, b.y + b.h / 2);
}
void drawPartialToggle(Rect b) {
  int dy;
  for (dy = 1; dy < b.h; dy += 3)
    line(b.x + b.w / 4,  b.y + dy,    b.x + b.w * 3/4,  b.y + dy);
  line(b.x + b.w /   4,  b.y + 1,   b.x + b.w /   4,  b.y + dy);
  line(b.x + b.w * 3/4,  b.y + 1,   b.x + b.w * 3/4,  b.y + dy);
}

