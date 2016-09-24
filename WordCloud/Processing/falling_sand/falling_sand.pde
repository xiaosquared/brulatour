// 9.22.16
// 
// Falling Sand
//

import java.util.*;

int radius = 1;
float speed = 2;
int n = 15;

ArrayList<Particle> splash;
int[] sand_heights;

void setup() {
  size(600, 600, P2D);
  background(30);
  fill(200);
  noStroke();
  
  splash = new ArrayList<Particle>();
  sand_heights = new int[width];
  for (int i = 0; i < width; i++) {
    sand_heights[i] = height;
  }
}

void draw() {
  background(30);
  Iterator<Particle> it = splash.iterator();
  while(it.hasNext()) {
    Particle p = it.next();
    p.run();
    int x = (int) p.pos.x;
    int y = (int) p.pos.y;
    if (x > 0 && x < width && 
    ((y-sand_heights[x] < 2 && y-sand_heights[x] > 1) || y > height)) {
       sand_heights[x]--;
       it.remove();
    }
  }
  drawSand();
}

void drawSand() {
  for (int x = 0; x < width; x++) {
    rect(x, sand_heights[x], radius, height-sand_heights[x]);
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
   
    splash.add(new Particle(p, v, radius));
  }
}