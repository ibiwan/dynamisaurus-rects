rexNode root;
ClickNet clickRoot;

int margin = 2;
int useTextSize = 12;

void setup() {
  size(800, 600);
  root = new rexNode(new Sz(width, height));
  String sData = join(loadStrings("dnd.json"), "");
  textSize(useTextSize);
  
  HashMap<String, Object> pData = parseJsonObject(sData);
  
  for (int i = 0; i < specials.length; i++) {
    specials[i].chew(pData);
  }
  traverseSomething(pData, root);
}

void draw() {
  // display's width follows mouse if below is uncommented
  // root.max.w = (mouseX > 0) ? mouseX : width;
  
  background(255);
  root.drawasroot(0, 0, 0);
}

