// 11.12.17
//
// Fill Trapezoid
//
// Filling a trapezoid with variable height and width rectangles
//


Trapezoid trapezoid;

void setup() {
  size(1200, 800);
  
  trapezoid = new Trapezoid(new PVector(400, 100), new PVector(700, 100), 
                            new PVector(40, 600), new PVector(1120, 600), 25);
  //trapezoid = new Trapezoid(new PVector(40, 100), new PVector(1120, 100), 
  //                          new PVector(400, 600), new PVector(700, 600),
  //                          25);                            
  background(30);
}

void draw() { 
  
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}

void keyPressed() {
  background(30);
  trapezoid.addBrick(50, 250);
  trapezoid.draw();
}