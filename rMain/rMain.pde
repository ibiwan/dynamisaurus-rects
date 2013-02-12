rexNode root;
ClickNet clickRoot;
rexObject pData;

int margin = 3;
int useTextSize = 12;
PFont normalFont;
PFont italicFont;
PFont monospFont;
String filename = "dnd.json";
Pt scrollPt = new Pt(0, 0);

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
  // display's width follows mouse if below is uncommented
  // root.max.w = (mouseX > 0) ? mouseX : width;

  background(255);
  root.drawasroot(scrollPt, 0);
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

void saveFile() {
  rexObject saveData = new rexObject(pData);
  for (int i = 0; i < specials.length; i++)
    saveData.m.put(specials[i].key, specials[i].data);
  String[] lines = split(getJsonString(pData), '\n');
  saveStrings(filename, lines);
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

