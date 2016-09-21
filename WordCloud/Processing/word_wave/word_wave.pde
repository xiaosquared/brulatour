// 9.21.16
//
// Word Water
//
// Draw words at the surface of the water
// Space to toggle verticle lines
//
// Q: How to make the words form a "gradient"?

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nsugar\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane\nslavery\nReconstruction\nantibellum";
String[] words = new String[25];
SpringWaveWords word_water;

PFont font;
int font_size = 7;

void setup() {
  size(1200, 600, P2D);
  background(50);
  stroke(80);
  fill(200);
  
  words = split(phrase, '\n');
  font = createFont("American Typewriter", font_size);   
  textFont(font, font_size);
  
  textAlign(CENTER, TOP);
  
  word_water = new SpringWaveWords(new PVector(1, 350), 2, 300, words);
}

void draw() {
  background(50);
  word_water.update();
  word_water.draw();
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
  word_water.mousePressed();
}

void mouseDragged() {
  word_water.mouseDragged();
}

void mouseReleased() {
  word_water.mouseReleased();
}

void keyPressed() {
  if (key == ' ')
    word_water.bDrawLine = !word_water.bDrawLine;  
}