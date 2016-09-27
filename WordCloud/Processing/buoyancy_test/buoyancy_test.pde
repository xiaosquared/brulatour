// 9.27.16
//
// Buoyancy Test
//
// Objects that float on water 

import java.util.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

Wave w;

Block b;
int water_level = 400;
float water_density = 0.0007;

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
  
  // Block
  if (b != null) {
    b.update();
    b.draw();
    
    if (b.pos.y >= water_level && !b.inWater) {
      b.inWater = true;
      
      int left = w.getSelectedSpringIndex((int)b.pos.x - (int)b.w/2);
      int right = floor(left+b.w/(w.radius*2));
      for (int i = left; i < right; i++) {
        w.springs[i].pos.y = b.pos.y + b.h/2 + w.radius;
      }      
      
      createSplash(w.springs[left].pos.x, w.target_height);
      createSplash(w.springs[right].pos.x, w.target_height);
      createSplash(w.springs[(int)left+((right-left)/2)].pos.x, w.target_height);
    }
  }
  
  // Wave
  if (random(100) < 1) 
    w.perturb(floor(random(4, width-4)));
  w.run();
  
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
  b = new Block(mouseX, -20, random(50, 120), random(10, 30));
}