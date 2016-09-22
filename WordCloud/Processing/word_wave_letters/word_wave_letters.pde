// 9.22.16
//
// Word Wave Letters
//
// letters controlled by individual springs
// makes the words look like part of the wave, not just floating ont he water!

PFont font;
Wave wave;
int PARTICLE_WIDTH = 8;

void setup() {
  size(1200, 600, P2D);
  background(50);
  stroke(80);
  fill(200);
  
  font = createFont("American Typewriter", 24);
  textFont(font, 24);
  textAlign(LEFT, TOP);
  
  wave = new Wave(new PVector(1, 350), PARTICLE_WIDTH, width/PARTICLE_WIDTH);
}

void draw() {
  background(50);
  wave.update();
  wave.draw();
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
  wave.mousePressed();
}

void mouseDragged() {
  wave.mouseDragged();
}

void mouseReleased() {
  wave.mouseReleased();
}

void keyPressed() {
  if (key == ' ')
    wave.bDrawLine = !wave.bDrawLine;  
}