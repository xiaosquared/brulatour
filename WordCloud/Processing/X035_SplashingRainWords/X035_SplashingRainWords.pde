// 9.28.16
//
// Splashing Rain Words
//
// Same as Splashing Rain except everything is rendered as letters!

import java.util.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

ParticleManager pm;
String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane";
String[] words = new String[20];
int font_size = 12;
PFont font;

void setup() {
  size(1200, 600, P2D);
  background(30);
  
  words = split(phrase, '\n');
  font = createFont("American Typewriter", font_size);
  textFont(font, font_size);
  
  Ani.init(this);
  pm = new ParticleManager();
  pm.w.initText(words);
}

void draw() {
  background(30);
  pm.update();
}

void mousePressed() {
  println(mouseX, mouseY);
  pm.w.perturb(mouseX);
}

void keyPressed() {
  pm.renderLetters = !pm.renderLetters;
}