import org.json.*;

JSONode root;
ClickNet clickRoot;

int margin = 2;
int textSize = 12;

void setup() {
  size(800, 600);
  root = new JSONode(new Sz(-1, -1), new Sz(width, height));
  String sDnd = join(loadStrings("dnd.json"), "");
  textSize(textSize);
  //println(sDnd);
  
  try {
    JSONObject jDnd = new JSONObject(sDnd);
    
    JSONArray ordering = jDnd.getJSONArray("ordering");
    orderingMap = parseOrdering(ordering);
    jDnd.remove("ordering");

    JSONObject primaries = jDnd.getJSONObject("primaries");
    primariesMap = parsePrimaries(primaries);
    jDnd.remove("primaries");
    
    parseJSONUnknown(jDnd, "", root, null);
  }
  catch (JSONException e) {
    println ("There was an error parsing the JSONObject.");
    println(e.toString());
  };
}

void draw() {
  // display's width follows mouse if below is uncommented
  // root.max.w = (mouseX > 0) ? mouseX : width;
  
  background(255);
  root.drawasroot(0, 0, 0);
}

