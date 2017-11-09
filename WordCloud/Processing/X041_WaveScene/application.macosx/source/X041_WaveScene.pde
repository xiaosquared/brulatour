// 10.3.16
//
// Wave Scene
//
// Combined system of wave, rain, splash made out of words, and big words falling into water
//
// 10.4.16: smoothed out FloatyWavyText that were jittery during rain


import java.util.*;
import de.looksgood.ani.*;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane";
String[] words = new String[20];
int font_size = 100;
PFont font;

PVector g = new PVector(0, 0.1);
MultiWave mw;
MultiRain r;
Splashing sp;

FloatyWavyText fwt;

boolean renderLetters = true;
boolean isRaining = false;

int rainDuration = 2000;
int lastRainTime = 0;

void setup() {
  fullScreen(P2D);
  background(30);
  
  initWords();
  Ani.init(this);
  mw = new MultiWave(5, new PVector(-20, height-200), new PVector(width+200, height-20), 4, 220, 50);
  mw.initText(words, 12, 28);
  
  sp = new Splashing();
  r = new MultiRain(mw, sp, words, 12);
  lastRainTime = millis();
  
  initFallingWord();
}

void draw() {
  background(30);
  
  if (fwt != null) {
    if (fwt.opacity == 0)
      initFallingWord();
    
    fwt.update();
    fwt.draw();
    
    if (fwt.hittingWater())
      fwt.hitWater();
  }
  
  mw.update();
  mw.draw(renderLetters);
  sp.run(true); 
  r.run(true, isRaining);
  
  int current_time = millis();
  if (current_time - lastRainTime > rainDuration) {
    isRaining = !isRaining;
    lastRainTime = current_time;
    if (isRaining) {
      r.restart();
    }
    rainDuration = int(random(10, 20) * 1000); 
  }
}

void initWords() {
  words = split(phrase, '\n');
  font = createFont("American Typewriter", font_size);
  textFont(font, font_size);  
}

void initFallingWord() {
  fwt = new FloatyWavyText(words[(floor(random(words.length)))], random(70, 90), random(0, width*.66), -20, mw.waves[0]);
}

void mousePressed() {
  println(mouseX, mouseY);
}

void keyPressed() {
  switch(key) {
    case ' ':
      renderLetters = !renderLetters;
      break;
    case 'r':
      isRaining = !isRaining;
      lastRainTime = millis();
      if (isRaining)
        r.restart();
      break;
    case 'p':
      mw.waves[0].perturbRegion(100, 150, 20, sp);
      break;
  }
}