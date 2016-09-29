// 9.28.16
//
// Buoyant Wavy Text
//
// Floating text that moves with the waves

import java.util.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

String[] words;
int counter = 0;
PFont font;
int font_size = 40;

PVector g = new PVector(0, 0.5);  // force from gravity
float d = 0.03;  // drag coefficient 
int water_level = 400;
float water_density = 0.0008;

ArrayList<Particle> splashes;
int pps = 6;  // particles per splash
float splash_speed = 4.5;

Wave w;
FloatingWavyText t;

void setup() {
  size(600, 600, P2D);
  background(40);
  rectMode(CENTER);
  
  initWords();
  font = createFont("American Typewriter", font_size);
  textFont(font, font_size);
  
  Ani.init(this);
  w = new Wave(new PVector(2, 400), 2, width/4);
  splashes = new ArrayList<Particle>();
}

void draw() {
  background(40);

  if (t != null) {
    t.update();
    t.draw(w.springs);
    
    if (t.pos.y >= water_level && !t.inWater) {
      t.inWater = true;
      t.assignSprings(w.radius);
      
      // perturb wave
      int left = w.getSelectedSpringIndex((int)t.pos.x - (int)t.w/2);
      int right = floor(left+t.w/(w.radius*2));
      left = max(0, left);
      right = min(width, right);
      for (int i = left; i < right; i++) {
        w.springs[i].pos.y = t.pos.y + t.h/2 + w.radius;
      }
      
      createSplash(w.springs[left].pos.x, w.target_height);
      createSplash(w.springs[right].pos.x, w.target_height);
      createSplash(w.springs[(int)left+((right-left)/2)].pos.x, w.target_height);
    }
  }
  
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
  t = new FloatingWavyText(mouseX, mouseY, words[counter], font_size);
  counter++;
  counter = counter %3;
}

void initWords() {
  words = new String[3];
  words[0] = "Tremé";
  words[1] = "Vieux carré";
  words[2] = "Marigny";
}