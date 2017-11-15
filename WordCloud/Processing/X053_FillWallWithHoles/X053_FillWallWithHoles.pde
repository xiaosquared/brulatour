// 11.12.17
//
// Fill Wall with Holes
//
// holes are always rectangular
// specified by top left and bottom right corners

Trapezoid trapezoid;

void setup() {
  size(1200, 800);
  
  trapezoid = new Trapezoid(new PVector(400, 100), new PVector(700, 100), 
                            new PVector(40, 600), new PVector(1120, 600), 25);
  trapezoid.addHole(new PVector(437, 332), new PVector(640, 460));
  trapezoid.addHole(new PVector(676, 377), new PVector(792, 564));
  
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