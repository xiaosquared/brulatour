// Created 3.3.16
//
// Polygon Parser
//
// Reads a file and constructs polygons  
//

String filename = "test.json";
JSONArray values;
ArrayList<Polygon> polygons;

void setup() {
  size(800, 800);
  background(50);
  stroke(200);
  
  polygons = new ArrayList<Polygon>();
  polygonsFromJSON();
  noLoop();
}

void draw() {
  for (Polygon poly : polygons) {
    poly.draw();
  }
}

void polygonsFromJSON() {
  values = loadJSONArray(filename);
  for (int i = 0; i < values.size(); i++) {
    JSONArray jpoly = values.getJSONArray(i);
    Polygon poly = new Polygon();
    
    for (int j = 0; j < jpoly.size(); j++) {
      JSONArray jvertex = jpoly.getJSONArray(j);
      int x = jvertex.getInt(0);
      int y = jvertex.getInt(1);
      poly.addVertex(new PVector(x, y));
    }
    
    poly.complete();
    polygons.add(poly);
  }
}