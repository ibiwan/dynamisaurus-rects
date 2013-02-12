rexNode root;
ClickNet clickRoot;
rexObject pData;

int margin = 3;
int useTextSize = 12;
PFont normalFont;
PFont italicFont;
PFont monospFont;

void setup() {
  size(800, 600);
  textSize(useTextSize);
  normalFont = loadFont("SansSerif.plain-12.vlw");
  italicFont = loadFont("SansSerif.italic-12.vlw");
  monospFont = loadFont("Monospaced.bold-12.vlw");
  textFont(normalFont);
  loadJson("dnd.json");
  setupStringKeys();
}

void draw() {
  // display's width follows mouse if below is uncommented
  // root.max.w = (mouseX > 0) ? mouseX : width;

  background(255);
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
  String filename = "testJson/" + files[r] + ".json";
  println(filename);
  return filename;
}

void setupStringKeys() {
  stringKeys = new HashMap<Character, Boolean>();
  for(char i = 'a'; i <= 'z'; i++)
    stringKeys.put(i, true);
  for(char i = 'A'; i <= 'Z'; i++)
    stringKeys.put(i, true);
  for(char i = '0'; i <= '9'; i++)
    stringKeys.put(i, true);
  stringKeys.put('=', true);
  stringKeys.put('-', true);
  stringKeys.put('.', true);
  stringKeys.put(' ', true);
  stringKeys.put('[', true);
  stringKeys.put(']', true);
  stringKeys.put('(', true);
  stringKeys.put(')', true);
}

