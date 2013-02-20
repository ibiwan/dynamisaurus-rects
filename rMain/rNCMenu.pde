class rexNodeContextMenuItem extends rexNodeString {
  rexNodeContextMenuItem(String s) {
    super(s);
  }
  protected void clickReceived(Pt p) {
    println("menu item clicked: " + value);
    super.clickReceived(p);
  }
}

class rexNodeContextMenu extends rexNodeArray {
  Pt iconLoc = new Pt(0, 0);
  
  void draw(ClickNet net) {
    clickRoot = new ClickNet(new Rect(0, 0, width, height), this);
    super.draw(iconLoc, 255, clickRoot);
  }
}

rexNodeContextMenu popUp = null;

