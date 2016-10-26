// 9.22.16
//
// Splash Particles
//
// droplets splaying out in all directions

import java.util.*;

ArrayList<Particle> splash;

int n = 15;
int speed = 2;

void setup() {
  size(600, 600);
  background(30);
  fill(200);
  noStroke();
  
  splash = new ArrayList<Particle>();
}

void draw() {
  background(30);
  Iterator<Particle> it = splash.iterator();
  while(it.hasNext()) {
    Particle p = it.next();
    p.run();
    if (p.pos.x < 0 || p.pos.x > width || p.pos.y > height) {
      it.remove();
    }
  }
}

void mousePressed() {
  createSplash(mouseX, mouseY);
}

void mouseDragged() {
  createSplash(mouseX, mouseY);
}

void createSplash(int x, int y) {
  for (int i = 0; i < n; i ++) {
    float radians = random(0, PI);
    PVector v = new PVector(speed*cos(radians) + random(-1, 1),
                            -speed*sin(radians) + random(-1, 1));
    PVector p = new PVector(x + random(-5, 5), y + random(-12, 12));
   
    splash.add(new Particle(p, v));
  }
}