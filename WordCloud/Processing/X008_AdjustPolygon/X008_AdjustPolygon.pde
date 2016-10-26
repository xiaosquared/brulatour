// 2.20.16
//
// Change the shape of a polygon by clicking and dragging its vertices

Polygon poly;

void setup() {
  size(600, 600);
  noFill();
  stroke(200);
  background(50);
  
  poly = new Polygon();
  poly.addDefaultVertices();
  poly.computeBoundingBox();
  poly.printInfo();
}

void draw() {
  background(50);
  poly.draw(true, true);
}

void mousePressed() {
  poly.selectVertex(mouseX, mouseY);
}

void mouseDragged() {
  poly.setSelectedVertex(mouseX, mouseY);
}

void mouseReleased() {
  poly.unselectVertex();
}