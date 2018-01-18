// 1.15.18
//
// Pianist and Staff Lines
//bxb
//

PImage img;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCarondolet Canal\nsugar\ntobacco\ncotton\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\ncypress\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nDowntown\nhurricane\nslavery\nReconstruction\nantibellum";
PFont font;
int default_font_size = 20;
WordManager wm;

WordImage pianist;
WordImage piano;
float x_unit = 10; 
float y_unit = 4;
float px = 50; float py = 350;
int hue = 200;
boolean bw_mode = true;

StaffLines staff;

int count = 0;

void setup() {
  size(1200, 800, P2D);
  smooth(4);
  textAlign(LEFT, TOP);
  colorMode(HSB, 360, 100, 100);

  initWords();
 
  pianist = new WordImage(loadImage("pianist-only.gif"), x_unit, y_unit, hue);
  pianist.setTranslation(px, py);
 
  piano = new WordImage(loadImage("piano.gif"), x_unit, y_unit, hue);  
  piano.setTranslation(px, py);
  
  background(0);
  pianist.fillAll();
  piano.fillAll();
  
  staff = new StaffLines();
}

void initWords() {
  font = createFont("American Typewriter", default_font_size);
  textFont(font, default_font_size);
  wm = new WordManager();
  wm.addAllWords(phrase);
}

void draw() {
  background(0);
  pianist.draw();
  piano.draw();
  
  staff.update();
  staff.draw();
  
  count ++;
  if (count % 20 == 0) {
    pianist.reset();
    pianist.fillAll();
  }
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}