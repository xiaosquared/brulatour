// 12.5.17
//
// Corner houses
//
// Roofs that slant only to one side
// Railings for porticos and for stories
// Windows - doesn't draw it on the farthest most one
//

boolean bw_mode = true;
boolean go = false;

Roof r1, r2;
Portico p1, p2;
Story s1;
float x = 200;
float y = 100;
float panel_width = 150;
float col_width = 10;
float story_width = 250;
float roof_height = 100;
float story_height = 180;
float layer_thickness = 4;
int wall_hue = 50;
int railing_hue = 100;
int window_hue = 280;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCarondolet Canal\nsugar\ntobacco\ncotton\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\ncypress\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nDowntown\nhurricane\nslavery\nReconstruction\nantibellum";
PFont font;
int default_font_size = 20;
WordManager wm;


void setup() {
  size(1280, 800);
  textAlign(LEFT, TOP);
  colorMode(HSB, 360, 100, 100);

  font = createFont("American Typewriter", 60);
  textFont(font, default_font_size);

  wm = new WordManager();
  wm.addAllWords(phrase);

  background(30);
  
  r1 = new Roof(x, y, story_width, roof_height, 45, false, layer_thickness, railing_hue);
  r1.addChimney(1, 20, 30);
  r1.fillAll();
  r1.draw();
  
  p1 = new Portico (x, y+roof_height, story_width, story_height, 2, col_width, layer_thickness, false, wall_hue, window_hue);
  p1.addRailing(10, 10, 10, railing_hue);
  p1.addArchWindows(20, 0, 30, 10, window_hue);
  p1.fillAll();
  p1.draw();
  
  r2 = new Roof(x+r1.width*1.5, y, story_width*2, roof_height, 45, true, layer_thickness, railing_hue);
  r2.addPointedWindow(1, 30, 20, story_width * 0.9, 0, 8, window_hue);
  r2.addChimney(1, 20, 40);
  r2.fillAll();
  r2.draw();
  
  p2 = new Portico(x+r1.width*1.5, y+roof_height, story_width*2, story_height, 4, col_width, layer_thickness, true, wall_hue, window_hue);
  p2.addRailing(10, 10, 10, railing_hue);
  p2.addWindows(20, 20, 10, 10, window_hue);
  p2.fillAll();
  p2.draw();
  
  s1 = new Story(x, y + 2 * story_height, story_width * 1.5, story_height, layer_thickness, wall_hue);
  s1.addRailingSides(10, 20, 10, 50, 0, railing_hue);
  s1.addWindows(3, 20, 20, 40, 30, 10, window_hue);
  s1.fillAll();
  s1.draw();
  
}

void draw() {

}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}

void keyPressed() {
  if (key == 32)
    go = !go;
  else if (key == 10) { 
    p1.reset();
    r1.reset();
    p2.reset();
    r2.reset();
    s1.reset();
    
    p1.fillAll();
    r1.fillAll();
    p2.fillAll();
    r2.fillAll();
    s1.fillAll();
    
    background(30);
    p1.draw();
    r1.draw();
    p2.draw();
    r2.draw();
    s1.draw();
  }
}