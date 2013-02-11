rexNode root;
rexNode selected = null;
boolean editMode = false;
String editString = null;
ClickNet clickRoot;

int margin = 3;
int useTextSize = 12;

void setup() {
  size(800, 600);
  textSize(useTextSize);
  loadJson("dnd.json");
}

void draw() {
  // display's width follows mouse if below is uncommented
  // root.max.w = (mouseX > 0) ? mouseX : width;

  background(255);
  root.drawasroot(new Pt(0, 0), 0);
}

void loadJson(String filename) {
  String sData = join(loadStrings(filename), "");
  rexObject pData = parseJsonObject(sData);

  for (int i = 0; i < specials.length; i++)
    specials[i].chew(pData);

  frame.setTitle(filename);
  root = new rexNode(new Sz(width, height));
  root.addChild(buildSomething(pData, null));
}

String randomFile() {
  String[] files = {"google", "twitter", "facebook", "colors", "flickr", "youtube", "iphone", "customer", "products", "interoperability"};
  int r = (int)random(files.length);
  String filename = "testJson/" + files[r] + ".json";
  println(filename);
  return filename;
}

