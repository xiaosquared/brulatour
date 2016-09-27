// 9.27.16
//
// Falling into Wave 
//
// Objects fall into water, sinks to bottom

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

Wave w;
Rectangle r;

void setup() {
  size(600, 600);
  background(40);
  Ani.init(this);
  
  w = new Wave(new PVector(2, 400), 2, width/4);
}

void draw() {
  background(40);
  if (random(100) < 1) 
    w.perturb(floor(random(4, width-4)));
  w.run();
  
  if (r != null) {
    r.run();
    if (r.pos.y > w.target_height && !r.inWater) {
      r.vel.y = 0;
      r.acc.y = 0.1;
      r.d = 0.005;
      r.inWater = true;
      
      int fs = w.getSelectedSpringIndex((int)r.pos.x);
      for (int i = fs; i < fs+r.w/(w.radius*2); i++) {
        w.springs[i].pos.y = r.pos.y + r.h + w.radius;
        w.springs[i].vel.y = 0;
      }
    }
    else if (r.pos.y + r.h > height) {
      r.pos.y = height - r.h;
      r.vel.y = 0;
      r.acc.y = 0;
    }
  }
}

void mousePressed() {
  r = new Rectangle(mouseX, mouseY, random(20, 80), random(10, 20)); 
}