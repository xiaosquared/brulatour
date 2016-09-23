// 9.22.16
//
// Word Wave Placing
// 
// Test for how "gradient of words" will look
// Click to place random words, lower words will appear smaller 
//
// after testing: might look better if words are in several rows of waves? 

import java.util.ArrayList;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane";
String[] words = new String[20];

PFont font;
int font_size = 30;

Wave wave;
int PARTICLE_WIDTH = 4;

void setup() {
  size(1200, 600, P2D);
  background(30);
  stroke(80);
  fill(200);
  
  words = split(phrase, '\n');
  font = createFont("American Typewriter", font_size);
  textFont(font, 24);
  
  wave = new Wave(new PVector(1, 350), PARTICLE_WIDTH, width/PARTICLE_WIDTH);
}

void draw() {
  background(30);
  wave.update();
  wave.draw();
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
  wave.mousePressed();
  
  if (mouseY > wave.getRestingHeight()) {
    int index = floor(random(words.length));
    String word = words[index];
    
    float w_size = map(mouseY, 350, 600, 24, 2);
    wave.addText(word, w_size, mouseX, mouseY);
  }
}

void mouseDragged() {
  wave.mouseDragged();
}

void mouseReleased() {
  wave.mouseReleased();
}

void keyPressed() {
  if (key == ' ')
    wave.bDrawLine = !wave.bDrawLine;  
}