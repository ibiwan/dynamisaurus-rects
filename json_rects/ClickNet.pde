class ClickNet {
  Box box;
  JSONode target;
  ClickNet[] children = {};
  ClickNet(Box b, JSONode t) {
    box = b;
    target = t;
  }
  void add(ClickNet net) {
    children = (ClickNet[]) append(children, net);
  }
  boolean sendClick(Pt p) {
    if (!box.contains(p)) {
      return false;
    }
    for (int i = 0; i < children.length; i++) {
      if (children[i].sendClick(p)) {
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

