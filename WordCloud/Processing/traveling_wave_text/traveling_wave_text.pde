// 9.30.16
//
// Traveling Wave Text
//
// Persistent ambient waves with words!

import de.looksgood.ani.*;

Wave w;
WavyText wt;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane";
String[] words = new String[20];
int font_size = 24;
PFont font;

void setup() {
  size(1200, 600, P2D);
  background(30);
  
  //words = split(phrase, '\n');
  font = createFont("American Typewriter", font_size);
  textFont(font, font_size); 
  
  Ani.init(this);
  w = new Wave(new PVector(-20, 450), new PVector(1202, 450), 4);
  w.startWave();
  
}

void draw() {
  background(30);
  w.update();
  w.draw(false);
}