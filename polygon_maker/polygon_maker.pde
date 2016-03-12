// Created 3.3.16
//
// Polygon Maker
//
// A tool to help us create polygons by tracing an image
// TODO: rectangular sized holes in polygons!
//
// NOTE: Apparently, polygons must be defined clockwise

PImage house;

Polygon polyTemp;
ArrayList<Polygon> polys;

void setup() {
  size(800, 800);
  noFill();
  house = loadImage("house.jpg");
  
  polyTemp = new Polygon(true);
  polys = new ArrayList<Polygon>();
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
  for (int i = 0; i < polys.size(); i++) {
    Polygon poly = polys.get(i);
    JSONArray jpoly = new JSONArray();
    
    for (int j = 0; j < poly.vertices.length; j++) {
      JSONArray jvertex = new JSONArray();
      jvertex.setInt(0, (int) poly.vertices[j].x);
      jvertex.setInt(1, (int) poly.vertices[j].y);
      jpoly.setJSONArray(j, jvertex);
    }
    
    values.setJSONArray(i, jpoly);
  }
  println(values);
  saveJSONArray(values, "data/polygons.json");
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
  else if (keyCode == 32) {
    saveJSON();
  }
}