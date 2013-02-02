rexNode root;
ClickNet clickRoot;

int margin = 2;
int useTextSize = 12;

void setup() {
  size(800, 600);
  root = new rexNode(new Sz(-1, -1), new Sz(width, height));
  String sDnd = join(loadStrings("dnd.json"), "");
  textSize(useTextSize);
  
  HashMap<String, Object> pDnd = parseJsonObject(sDnd);
  
  if (pDnd.containsKey("ordering")) {
    orderingMap = parseOrdering((ArrayList)pDnd.get("ordering"));
    pDnd.remove("ordering"); 
  }

  if (pDnd.containsKey("primaries")) {
    primariesMap = parsePrimaries((HashMap<String, Object>)pDnd.get("primaries"));
    pDnd.remove("primaries"); 
  }
  traverseJsonSomething(pDnd, "", root, null);
}

void draw() {
  // display's width follows mouse if below is uncommented
  // root.max.w = (mouseX > 0) ? mouseX : width;
  
  background(255);
  root.drawasroot(0, 0, 0);
}

