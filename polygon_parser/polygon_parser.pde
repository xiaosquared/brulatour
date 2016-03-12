// Created 3.3.16
//
// Polygon Parser
//
// Reads a JSON file and constructs polygons based on specified points  
// Enables us to select diff polygons

String filename = "polygons.json";
JSONArray values;
ArrayList<Polygon> polygons;
Polygon selectedPoly;
boolean drawPolygons = true;

color selectedColor = color(127, 255, 255);
color normalColor = color(200);

void setup() {
  size(800, 800);
  background(50);
  stroke(200);
  
  polygons = new ArrayList<Polygon>();
  polygonsFromJSON();
  
}

void draw() {
  background(50);
  if (drawPolygons) {
    for (Polygon poly : polygons) {
      poly.draw();
    }
  }
}

void mousePressed() {
  if (selectedPoly != null) {
    selectedPoly.setColor(normalColor);
    selectedPoly = null;
  }
  
  for (Polygon poly : polygons) {
    if (poly.contains(mouseX, mouseY)) {
      selectedPoly = poly;
      selectedPoly.setColor(selectedColor);
    }
  }
}



void keyPressed() {
  if (key == 'p') {
    drawPolygons = !drawPolygons;
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