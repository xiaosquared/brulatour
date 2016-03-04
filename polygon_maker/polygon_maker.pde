// Created 3.3.16
//
// Polygon Maker
//
// A tool to help us create polygons by tracing an image
// Also enables us to select diff polygons
// TODO: rectangular sized holes in polygons!

PImage house;

Polygon polyTemp;
ArrayList<Polygon> polys;

JSONObject json;

void setup() {
  size(800, 800);
  noFill();
  house = loadImage("house.jpg");
  
  polyTemp = new Polygon(true);
  polys = new ArrayList<Polygon>();
  
  json = new JSONObject();
  json.setInt("id", 0);
  json.setString("name", "xx");
  saveJSONObject(json, "data/polygons.json");
}

void draw() {
  background(255);
  image(house, (width-house.width)/2, (height-house.height)/2);
  
  polyTemp.draw(true, true);
  
  for (Polygon poly : polys) {
    poly.draw();
  }
}

void saveJSON() {
  JSONArray values = new JSONArray();
  for (Polygon poly : polys) {
    for (int i = 0; i < poly.vertices.length; i++) {
      JSONArray jvertex = new JSONArray();
      jvertex.setInt(0, (int) poly.vertices[i].x);
      jvertex.setInt(1, (int) poly.vertices[i].x);
    }
  }
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
  
  if (polyTemp.inProgress)
    polyTemp.addVertex(new PVector(mouseX, mouseY));
}

void keyPressed() {
  if (key == 'p') {
    polyTemp = new Polygon(true);    
  } 
  else if (keyCode == 10) {
    polyTemp.complete();
    polys.add(polyTemp);
  }
}