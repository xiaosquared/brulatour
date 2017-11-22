// 11.21.17
//
// Filling Order
//
// Have wall and window that are part of the same floor increment 
// layers at the same time

Wall wall;
float x = 100;
float y = 100;
float width = 600;
float height = 300;
float top_margin = 80;
float bottom_margin = 0;
float side_margin = 50;
float in_between = 50;
float gap_with_wall = 20;
int window_hue = floor(random(0, 360));

ArrayList<CrownWindow> windows;
float layer_thickness = 6;
CrownWindow win;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCarondolet Canal\nsugar\ntobacco\ncotton\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\ncypress\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nDowntown\nhurricane\nslavery\nReconstruction\nantibellum";
PFont font;
int default_font_size = 20;
WordManager wm;

Word word;
boolean success = true;

Etage floor;

void setup() {
  size(1280, 800);
  stroke(200);
  textAlign(LEFT, TOP);
  colorMode(HSB, 360, 100, 100);
  background(30);
  
  font = createFont("American Typewriter", 60);
  textFont(font, default_font_size);
  
  wm = new WordManager();
  wm.addAllWords(phrase);
  float min_brick_width = wm.getMinWidth(layer_thickness);
  
  wall = new Wall(x, y, x+width, y+height, layer_thickness);
  wall.min_brick_width = min_brick_width;
  
  windows = wall.addCrownWindows(3, top_margin, bottom_margin, side_margin, in_between, gap_with_wall, window_hue);
  
  floor = new Etage(wall, windows);
}

void draw() {
  background(30);
  floor.addWord();
  floor.draw();
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}