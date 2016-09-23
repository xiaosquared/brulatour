import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

// 9.23.16
//
// Waving Ambient

Wave w1;
Wave w2;
Wave w3;
 
float wave_top;
int radius = 2;

void setup() {
  size(1200, 600, P2D);
  background(30);
  stroke(100);
  
  Ani.init(this);
  w1 = new Wave(new PVector(2, 350), radius, width/(radius * 2));
  w2 = new Wave(new PVector(2, 400), radius, width/(radius * 2)); 
}

void draw() {
  background(30);
  
  if (random(80) < 1) { w1.perturb(floor(random(radius, width-radius))); }
  if (random(80) < 2) { w2.perturb(floor(random(radius, width-radius))); }
  
  fill(250);
  w1.update();
  w1.draw();
  
  fill(170);
  w2.update();
  w2.draw();
}



void mousePressed() {
  w1.perturb(mouseX);
}