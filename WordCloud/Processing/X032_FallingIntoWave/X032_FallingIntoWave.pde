// 9.27.16
//
// Falling into Wave 
//
// Objects fall into water, splash, and sink to bottom

import java.util.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

Wave w;
Rectangle r;
ArrayList<Particle> splashes;
int pps = 6;  // particles per splash
float splash_speed = 4.5;

void setup() {
  size(600, 600);
  background(40);
  Ani.init(this);
  
  w = new Wave(new PVector(2, 400), 2, width/4);
  splashes = new ArrayList<Particle>();
}

void draw() {
  background(40);
  if (random(100) < 1) 
    w.perturb(floor(random(4, width-4)));
  w.run();
  
  if (r != null) {
    r.run();
    
    // hitting water
    if (r.pos.y > w.target_height && !r.inWater) {
      r.inWater = true;
      
      int left = w.getSelectedSpringIndex((int)r.pos.x);
      int right = floor(left+r.w/(w.radius*2));
      for (int i = left; i < right; i++) {
        w.springs[i].pos.y = r.pos.y + r.h + w.radius;
        w.springs[i].vel.y = 0;
      }
      
      createSplash(w.springs[left].pos.x, w.target_height);
      createSplash(w.springs[right].pos.x, w.target_height);
      createSplash(w.springs[(int)left+((right-left)/2)].pos.x, w.target_height);
    }
    
    // hitting bottom
    else if (r.pos.y + r.h > height) {
      r.pos.y = height - r.h;
      r.vel.y = 0;
      r.acc.y = 0;
    }
  }
  
  // splashes
  Iterator<Particle> it = splashes.iterator();
  while(it.hasNext()) {
    Particle p = it.next();
    p.run();
    if (p.isDead()) {
      it.remove();
    }
  }
}

void createSplash(float x, float y) {
  for (int i = 0; i < pps; i ++) {
    float radians = random(0, PI);
    PVector v = new PVector(splash_speed*cos(radians)/2 + random(-1, 1),
                              -splash_speed*sin(radians) + random(-1, 1));
    PVector p = new PVector(x + random(-5, 5), y + random(-12, 12));
    PVector a = new PVector(0, .3);
    splashes.add(new SplashDrop(p, v, a));
  }
}

void mousePressed() {
  r = new Rectangle(mouseX, mouseY, random(20, 80), random(10, 20)); 
}