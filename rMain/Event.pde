class ClickNet {
  Rect bounds;
  rexNode target;
  ArrayList<ClickNet> children = new ArrayList<ClickNet>();
  ClickNet(Rect r, rexNode t) {
    bounds = r;   
    target = t;
  }
  void add(ClickNet net) {
    children.add(net);
  }
  boolean sendClick(Pt p) {
    if (!bounds.contains(p))
      return false;
    for (int i = 0; i < children.size(); i++)
      if (children.get(i).sendClick(p))
        return true;
    target.clickReceived(p);
    return true;
  }
}

// keyword function -- called by Processing environment
void mouseClicked() {
  clickRoot.sendClick(new Pt(mouseX, mouseY));

  //if (mouseEvent.getClickCount()==2) println("<double click>");
}

rexNode selected = null;
boolean editMode = false;
String editString = null;

void keyPressed() {
  if (key == ESC) {
    key = 0; // always trap ESC to keep from exiting
  }
}

void keyReleased() {
  if (selected != null && selected.keyReceived(key))
    key = 0; // trap any other key, IF handled
  else {
    String keycap = "";
    switch(key) {
      case ESC:       keycap = "ESC";       break;
      case ENTER:     keycap = "ENTER";     break;
      case RETURN:    keycap = "RETURN";    break;
      case TAB:       keycap = "TAB";       break;
      case DELETE:    keycap = "DELETE";    break;
      case BACKSPACE: keycap = "BACKSPACE"; break;
      default:
        keycap = Character.toString(key);
        break;
    }
    println("unhandled keypress: " + keycap);
  }
}

