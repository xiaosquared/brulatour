// 9.30.16
//
// Traveling Wave
//
// Persistent ambient movement from one direction

import de.looksgood.ani.*;

Wave w;

void setup() {
  size(1200, 600, P2D);
  background(30);
  
  Ani.init(this);
  w = new Wave(new PVector(-20, 450), new PVector(1202, 450), 4);
  w.startWave();
}

void draw() {
  background(30);
  w.update();
  w.draw(false);
}