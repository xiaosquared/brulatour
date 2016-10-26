// 9.21.16
//
// Models water surface as a line of connected springs
// (Spring class was formerly Particle)

SpringWater water;

void setup() {
  size(600, 600, P2D);
  background(50);
  stroke(80);
  fill(200);
  
  water = new SpringWater(new PVector(1, 350), 2, 150); 
}

void draw() {
  background(50);
  water.update();
  water.draw();
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
  water.mousePressed();
}

void mouseDragged() {
  water.mouseDragged();
}

void mouseReleased() {
  water.mouseReleased();
}