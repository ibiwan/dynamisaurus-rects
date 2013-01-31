class ClickNet {
  Rect bounds;
  JSONode target;
  ArrayList<ClickNet> children = new ArrayList<ClickNet>();
  ClickNet(Rect r, JSONode t) {
    bounds = r;
    target = t;
  }
  void add(ClickNet net) {
    children.add(net);
  }
  boolean sendClick(Pt p) {
    if (!bounds.contains(p)) {
      return false;
    }
    for (int i = 0; i < children.size(); i++) {
      if (children.get(i).sendClick(p)) {
        return true;
      }
    }
    target.clickReceived(p);
    return true;
  }
}

void mouseClicked() {
  clickRoot.sendClick(new Pt(mouseX, mouseY));
}

