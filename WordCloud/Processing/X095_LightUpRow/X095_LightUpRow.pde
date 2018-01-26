// 1.25.18
// 
// Lighting Up Row
//
// Lighting up a row of things
//

LightRow lr;

void setup() {
  size(1200, 800, P2D);
  background(0);
  
  lr = new LightRow();
}

void draw() {
  lr.draw();
  lr.update();
}

void mousePressed() {
  lr.lights.add(new Light(mouseX, mouseY, 50, false));
  lr.draw();
}