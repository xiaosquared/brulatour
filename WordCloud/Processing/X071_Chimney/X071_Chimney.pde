// 12.4.17
//
// Chimney
//
// Adding Chimneys to roofs. The position goes from 0 to 1, 
// where 0 is all the way left, 1 is all the way right
// If width of chimney is more than top of roof (like for pointed roofs)
// draws chimney exactly in the middle
//

boolean bw_mode = true;
boolean go = false;

Roof r1, r2;
Portico p1, p2;
float x = 200;
float y = 300;
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
  
  r1 = new Roof(x, y, story_width, roof_height, layer_thickness, railing_hue);
  r1.addChimney(1, 20, 30);
  p1 = new Portico (x, y+roof_height, story_width, story_height, 2, col_width, layer_thickness, wall_hue, window_hue);
  p1.addArchWindows(20, 20, 30, 10, window_hue);
  
  r2 = new Roof(x+r1.width*1.5, y, story_width*2, roof_height, 16, layer_thickness, railing_hue);
  r2.addPointedWindow(1, 30, 20, story_width * 0.9, 0, 8, window_hue);
  r2.addChimney(1, 20, 40);
  p2 = new Portico(x+r1.width*1.5, y+roof_height, story_width*2, story_height, 4, col_width, layer_thickness, wall_hue, window_hue);
  p2.addRailingTo(0, layer_thickness*2, 10, layer_thickness * 2, railing_hue);
  p2.addRailingTo(3, layer_thickness*2, 10, layer_thickness * 2, railing_hue);
  p2.addWindows(20, 20, 10, 10, window_hue);
}

void draw() {
  
  if (!go)
    return;
  
  delay(30);  
  background(30);
  r1.fillByLayer();
  p1.fillByLayer();
  r1.draw(false, false, true);
  p1.draw(false, false, true);
  
  r2.fillByLayer();
  p2.fillByLayer();
  r2.draw(false, false, true);
  p2.draw(false, false, true);
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
    background(30);
  } else if (key == 'c') {
    bw_mode = !bw_mode;
  }
}