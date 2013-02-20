ClickNet clickRoot;
Pt scrollPt = new Pt(0, 0);

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

// keyword function -- called by Processing environment
void mouseClicked() {
  float[] mouseVec = {mouseX, mouseY};
  float[] xMouse = null;
  PMatrix2D transform = new PMatrix2D(this.g.getMatrix());
  transform.invert();
  xMouse = transform.mult(mouseVec, xMouse);
  clickRoot.sendClick(new Pt(xMouse));
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


import java.awt.event.*;
void setupScrollResponse() {
  addMouseWheelListener(new MouseWheelListener() { 
    public void mouseWheelMoved(MouseWheelEvent mwe) { 
      mouseWheel(mwe.getWheelRotation());
  }}); 
}

void mouseWheel(int delta) {
  scrollPt.y -= 20 * delta;
  if (scrollPt.y > height)
  {
    scrollPt.y = height;
  }
  if (root.contents.bounds.h != -1 && scrollPt.y < -root.contents.bounds.h) {
    scrollPt.y = -root.contents.bounds.h;
  }
}

