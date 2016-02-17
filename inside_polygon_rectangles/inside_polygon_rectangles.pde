// 2.16.16
//
// Fill an arbitrary convex polygon with rectangles!

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
  
  noLoop();
}

void draw() {
  poly.draw();  
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
  println(poly.inside(mouseX, mouseY)); 
}