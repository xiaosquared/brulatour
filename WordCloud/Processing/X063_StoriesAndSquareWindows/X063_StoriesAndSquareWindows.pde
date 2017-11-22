// 11.21.17
//
// Stories and Square Windows
//
// Fixed a bug where words sometimes overlap!!!

Wall wall;
float x = 100;
float y = 100;
float width = 600;
float height = 300;
float layer_thickness = 6;

Window win;

//String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCarondolet Canal\nsugar\ntobacco\ncotton\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\ncypress\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nDowntown\nhurricane\nslavery\nReconstruction\nantibellum";
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
  
  //font = createFont("American Typewriter", 60);
  //textFont(font, default_font_size);
  
  ////wm = new WordManager();
  ////wm.addAllWords(phrase);
  //float min_brick_width = wm.getMinWidth(layer_thickness);
  
  wall = new Wall(x, y, x+width, y+height, layer_thickness);
  //wall.min_brick_width = min_brick_width;
 
  win = new Window(200, 200, 300, 150, 6, 120);
  win.addToWall(wall);
  //win.draw();
  
  wall.draw();
}

void draw() {
  
}

void keyPressed() {
  println("NEW ROUND");
  if (wall.isFilled) {
    background(30);
    wall.reset();
  }
  
  while (!wall.isFilled) {
    if (success)
    word = wm.getRandomWord();

  wall.addWordBrick(wm.getRandomWord(), true);
  
  if (! success) 
    wall.addWordBrick(wm.getRandomWord(), false);
  }
  wall.draw();
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}