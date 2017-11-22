// 11.20.17
//
// Wall with Crown Windows
//
// Filling everything with words
//
// Progress: 2:30pm-4:30pm - made wall and windows as holes in wall
// Progress: 4:30-5:10pm - filled wall with words
//
// - need bigger gap at the bottom of windows 
// - filling order for wall/windows
// 

Wall wall;
float x = 100;
float y = 100;
float width = 100;
float height = 50;
float top_margin = 10;
float bottom_margin = 0;
float side_margin = 10;
float in_between = 10;
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
  
  windows = wall.addCrownWindows(3, top_margin, bottom_margin, side_margin, in_between, window_hue);
  //for (CrownWindow w : windows) {
  //  w.draw();
  //}
  wall.draw();
  
}

void draw() {
  background(30);
  
  
  if (success)
    word = wm.getRandomWord();
    
  for (CrownWindow win : windows) { 
    success = win.addWordBrick(word, true);
    wall.addWordBrick(wm.getRandomWord(), true);
  }
  
  if (! success) {
    wall.addWordBrick(wm.getRandomWord(), false);
    for (CrownWindow win : windows) { 
      win.addWordBrick(word, false);
    }
  }
  
  wall.draw();
  
  for (CrownWindow win : windows) {
    win.draw();
  }
  
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}