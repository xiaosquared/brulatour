// 3.12.16
//
// Noise Test
//
// A circle wobbles in the center of the screen from the "noise" function

PVector position = new PVector(200, 200);
int d = 50;
int nScale = 20;

float xoff = 0;
float yoff = 100;

void setup() {
  size(400, 400);
}

void draw() {
  background(50);
  float nx = map(noise(xoff), 0, 1, -nScale, nScale);
  float ny = map(noise(yoff), 0, 1, -nScale, nScale);
  
  ellipse(position.x + nx, position.y + ny, d, d);
  
  xoff += 0.01;
  yoff += 0.02;
}