String filename = "dnd.json";

void setup() {
  size(800, 600);
  textSize(useTextSize);
  normalFont = loadFont("SansSerif.plain-12.vlw");
  italicFont = loadFont("SansSerif.italic-12.vlw");
  monospFont = loadFont("Monospaced.bold-12.vlw");
  textFont(normalFont);
  setupStringKeys();
  setupScrollResponse();
  loadJson(filename);
}

void draw() {
  // root.max.w = (mouseX > 0) ? mouseX : width; // display's width follows mouse if uncommented

  background(255);
  translate(scrollPt.x, scrollPt.y);
  root.drawasroot(new Pt(0, 0), 0);
}

void loadJson(String filename) {
  String sData = join(loadStrings(filename), "");
  pData = parseJsonObject(sData);

  for (int i = 0; i < specials.length; i++)
    specials[i].chew(pData);

  frame.setTitle(filename);
  buildRoot();
}

void buildRoot() {
  root = new rexNode(new Sz(width, height));
  root.addChild(buildSomething(pData, null));
}

String randomFile() {
  String[] files = {"google", "twitter", "facebook", "colors", "flickr", "youtube", "iphone", "customer", "products", "interoperability"};
  int r = (int)random(files.length);
  filename = "testJson/" + files[r] + ".json";
  return filename;
}

