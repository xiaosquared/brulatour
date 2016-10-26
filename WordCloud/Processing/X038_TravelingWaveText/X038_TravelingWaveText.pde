// 9.30.16
//
// Traveling Wave Text
//
// Persistent ambient waves with words!
// Plus rain and splashing!
// Plus floating words once in a while

import java.util.*;
import de.looksgood.ani.*;

PVector g = new PVector(0, 0.1);

Wave w, w2, w3, w4, w5;
float offset = 350;
boolean renderLetters = true;
boolean renderMultiple = true;
boolean raining = true;

Rain r, r2, r3, r4, r5;
int rdrops = 8;
Splashing sp;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane";
String[] words = new String[20];
int font_size = 100;
PFont font;

FloatyWavyText fwt;
float water_level = 400;
float water_density = 0.0008;

void setup() {
  size(1200, 600, P2D);
  background(30);
  
  words = split(phrase, '\n');
  font = createFont("American Typewriter", font_size);
  textFont(font, font_size); 
  
  r = new Rain(words, rdrops);
  r2 = new Rain(words, rdrops);
  r3 = new Rain(words, rdrops);
  r4 = new Rain(words, rdrops);
  r5 = new Rain(words, rdrops);
  sp = new Splashing();
  
  Ani.init(this);
  w = new Wave(new PVector(-20, 45 + offset), new PVector(1300, 350), 4);
  w.initText(words, 12, 0, w.springs.length);
  w.startWave();
  
  w2 = new Wave(new PVector(-20, 80 + offset), new PVector(1300, 380), 4);
  w2.initText(words, 16, 0, w.springs.length);
  w2.startWave();
  
  w3 = new Wave(new PVector(-20, 120 + offset), new PVector(1400, 410), 4);
  w3.initText(words, 20, 0, w.springs.length);
  w3.startWave();
  
  w4 = new Wave(new PVector(-20, 170 + offset), new PVector(1500, 450), 4);
  w4.initText(words, 24, 0, w.springs.length);
  w4.startWave();
  
  w5 = new Wave(new PVector(-20, 220 + offset), new PVector(1600, 490), 4);
  w5.initText(words, 28, 0, w.springs.length);
  w5.startWave();
}

void draw() {
  background(30);
  
  // floating text  
  if (fwt != null) {
    fwt.update();
    fwt.draw();
    
    if (fwt.start_pos.y >= water_level && !fwt.inWater) {
      fwt.inWater = true;
      fwt.vel.x = random(-3, 2);
    }
  }
  
  // rain
  r.run(w, sp, renderLetters, raining);
  r2.run(w2, sp, renderLetters, raining);
  r3.run(w3, sp, renderLetters, raining);
  r4.run(w4, sp, renderLetters, raining);
  r5.run(w5, sp, renderLetters, raining);
  sp.run(renderLetters);
  
  // waves
  w.update();
  fill(220);
  w.draw(renderLetters);
  if (renderMultiple) {
    w2.update();
    fill(180);
    w2.draw(renderLetters);
  
    w3.update();
    fill(140);
    w3.draw(renderLetters);
  
    w4.update();
    fill(100);
    w4.draw(renderLetters);
  
    w5.update();
    fill(60);
    w5.draw(renderLetters);
  }
}

void mousePressed() {
  fwt = new FloatyWavyText(words[(floor(random(words.length)))], random(60, 90), mouseX, -20);
}

void keyPressed() {
  if (key == ' ') {
    renderLetters = !renderLetters;
  }
  else if (key == 'm') {
    renderMultiple = !renderMultiple;
  }
  else if (key == 'r') {
    raining = !raining;
    if (raining) {
      r.restart();
      r2.restart();
      r3.restart();
      r4.restart();
      r5.restart();
    }
  }
}