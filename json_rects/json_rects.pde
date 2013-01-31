import org.json.*;

JSONode root;
ClickNet clickRoot;

int margin = 2;
int useTextSize = 12;

void setup() {
  size(800, 600);
  root = new JSONode(new Sz(-1, -1), new Sz(width, height));
  String sDnd = join(loadStrings("dnd.json"), "");
  textSize(useTextSize);
  
  try {
    JSONObject jDnd = new JSONObject(sDnd);
    
    orderingMap = parseOrdering(jDnd.getJSONArray("ordering"));
    jDnd.remove("ordering");

    primariesMap = parsePrimaries(jDnd.getJSONObject("primaries"));
    jDnd.remove("primaries");
    
    parseJSONUnknown(jDnd, "", root, null);
  }
  catch (JSONException e) { JSONExceptionDump (e); }
}

void draw() {
  // display's width follows mouse if below is uncommented
  // root.max.w = (mouseX > 0) ? mouseX : width;
  
  background(255);
  root.drawasroot(0, 0, 0);
}

