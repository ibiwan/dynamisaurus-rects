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
  
  if (pData.containsKey("ordering")) {
    orderingMap = parseOrdering((ArrayList)pData.get("ordering"));
    pData.remove("ordering"); 
  }

  if (pData.containsKey("primaries")) {
    primariesMap = parsePrimaries((HashMap<String, Object>)pData.get("primaries"));
    pData.remove("primaries"); 
  }
  traverseJsonSomething(pData, "", root, null);
}

void draw() {
  // display's width follows mouse if below is uncommented
  // root.max.w = (mouseX > 0) ? mouseX : width;
  
  background(255);
  root.drawasroot(0, 0, 0);
}

