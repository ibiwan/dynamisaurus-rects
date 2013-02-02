rexNode root;
ClickNet clickRoot;

int margin = 2;
int useTextSize = 12;

void setup() {
  size(800, 600);
  root = new rexNode(new Sz(-1, -1), new Sz(width, height));
  String sData = join(loadStrings("dnd.json"), "");
  textSize(useTextSize);
  
  HashMap<String, Object> pData = parseJsonObject(sData);
  
  for (int i = 0; i < specials.length; i++) {
    SpecialParser p = specials[i];
    if (pData.containsKey(p.key)) {
      p.digest(pData.get(p.key));
      pData.remove(p.key);
    }
  }
  traverseSomething(pData, "", root, null);
}

void draw() {
  // display's width follows mouse if below is uncommented
  // root.max.w = (mouseX > 0) ? mouseX : width;
  
  background(255);
  root.drawasroot(0, 0, 0);
}

