// 11.29.17
//
// Roof Windows
//
// Triangular-top gable windows in the roof
//

boolean bw_mode = true;

Roof roof;
PointedWindow win;

float three_width = 250;
float four_width = 300;
float story_height = 200;
float layer_thickness = 4;
int wall_hue = 50;
int railing_hue = 100;
int window_hue = 280;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCarondolet Canal\nsugar\ntobacco\ncotton\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\ncypress\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nDowntown\nhurricane\nslavery\nReconstruction\nantibellum";
PFont font;
int default_font_size = 20;
WordManager wm;

boolean go = false;

void setup() {
  size(1280, 800);
  textAlign(LEFT, TOP);
  colorMode(HSB, 360, 100, 100);

  font = createFont("American Typewriter", 60);
  textFont(font, default_font_size);

  wm = new WordManager();
  wm.addAllWords(phrase);

  background(30);
  //win = new PointedWindow(100, 100, 200, 300, 6, window_hue);
  //win.draw(true, true, false);
  
  roof = new Roof(400, 100, 400, 200, 16, 6, wall_hue);
  roof.addPointedWindow(1, 40, 40, 150, 30, 5, window_hue);
  roof.draw(true, true, false);
  
  Story s = new Story(100, 100, 200, 300, 6, window_hue);
  s.addWindows(1, 50, 50, 20, 30, 5, window_hue);
  s.draw(true, true, false);
}

void draw() {
  
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}

void keyPressed() {
  
}