// 10.3.16
//
// Multi wave
//
// A single object for many smaller waves that ambiently move

import java.util.*;
import de.looksgood.ani.*;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane";
String[] words = new String[20];
int font_size = 100;
PFont font;

MultiWave w;

boolean renderLetters = true;

void setup() {
  size(1200, 600, P2D);
  background(30);
  
  initWords();
  Ani.init(this);
  w = new MultiWave(5, new PVector(-20, 400), new PVector(1400, 580), 4, 220, 60);
  w.initText(words, 12, 28);
}

void draw() {
  background(30);
  w.update();
  w.draw(renderLetters);
}

void initWords() {
  words = split(phrase, '\n');
  font = createFont("American Typewriter", font_size);
  textFont(font, font_size);  
}

void mousePressed() {
  println(mouseX, mouseY);
}

void keyPressed() {
  switch(key) {
    case ' ':
      renderLetters = !renderLetters;
      break;
  }
}