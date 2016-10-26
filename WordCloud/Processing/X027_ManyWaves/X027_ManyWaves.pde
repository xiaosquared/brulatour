// 9.22.16
//
// Many Waves
//
// Several independent waves

Wave w1;
Wave w2;
Wave w3;

void setup() {
  size(1200, 600, P2D);
  background(30);
  noStroke();
  
  w1 = new Wave(new PVector(1, 400), 2, width/2);
  w2 = new Wave(new PVector(2, 350), 2, width/2);
  w3 = new Wave(new PVector(3, 300), 2, width/2);
}

void draw() {
  background(30);
  w1.update();
  w2.update();
  w3.update();
  
  stroke(50);
  fill(50);
  w1.draw();
  stroke(100);
  fill(100);
  w2.draw();
  stroke(150);
  fill(150);
  w3.draw();
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
  w1.mousePressed();
  w2.mousePressed();
  w3.mousePressed();
}

void mouseDragged() {
  w1.mouseDragged();
  w2.mouseDragged();
  w3.mouseDragged();
}

void mouseReleased() {
  w1.mouseReleased();
  w2.mouseReleased();
  w3.mouseReleased();
}