// 9.23.16
//
// Waving Ambient
// 
// Several rows of waves moving themselves randomly


import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

PFont font;

Wave w1;
Wave w2;
Wave w3;
Wave w4;
Wave w5;
 
float wave_top;
int radius = 2;

void setup() {
  size(1200, 600, P2D);
  background(30);
  stroke(100);
  
  font = createFont("American Typewriter", 24);
  textFont(font, 12);
  textAlign(LEFT, TOP);
  
  Ani.init(this);
  w1 = new Wave(new PVector(2, 380), radius, width/(radius * 2));
  w2 = new Wave(new PVector(2, 410), radius, width/(radius * 2));
  w3 = new Wave(new PVector(2, 440), radius, width/(radius * 2));
  w4 = new Wave(new PVector(2, 470), radius, width/(radius * 2));
  w5 = new Wave(new PVector(2, 500), radius, width/(radius * 2));
}

void draw() {
  background(30);
  
  if (random(100) < 1) { w1.perturb(floor(random(radius, width-radius))); }
  if (random(100) < 1) { w2.perturb(floor(random(radius, width-radius))); }
  if (random(100) < 1) { w3.perturb(floor(random(radius, width-radius))); }
  if (random(100) < 0.5) { w4.perturb(floor(random(radius, width-radius))); }
  if (random(100) < 0.5) { w5.perturb(floor(random(radius, width-radius))); }
  
  fill(250);
  //fill(50);
  w1.update();
  w1.draw();
  
  fill(200);
  //fill(100);
  w2.update();
  w2.draw();
  
  fill(150);
  w3.update();
  w3.draw();
  
  fill(100);
  //fill(200);
  w4.update();
  w4.draw();
  
  fill(50);
  //fill(250);
  w5.update();
  w5.draw();
}



void mousePressed() {
  w1.perturb(mouseX);
}