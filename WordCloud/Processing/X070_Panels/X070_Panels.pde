// 12.4.17
//
// Panels & Porticos
//
// Essentially a story but with columns between diff parts of the wall
// This sketch draws a bunch of different variations of them.
// Press any key to reset and refill
//

boolean bw_mode = true;

Panel panel;
Portico p1, p2, p3, p4, p5, p6, p7, p8, p9;
ArrayList<Portico> porticos;
float x = 100;
float y = 100;
float panel_width = 150;
float col_width = 10;
float story_width = 250;
float story_height = 100;
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
  p1 = new Portico(x, y, story_width, story_height, 3, col_width, layer_thickness, wall_hue, window_hue);
  p1.addWindows(20, 20, 20, 5, window_hue);
  p1.fillAll();
  p1.draw();
  
  p2 = new Portico (x + story_width * 1.5, y, story_width, story_height, 3, col_width, layer_thickness, wall_hue, window_hue);
  p2.addRailing(layer_thickness*2, 10, layer_thickness * 2, railing_hue);
  p2.addWindows(20, 0, 20, 5, window_hue);
  p2.fillAll();
  p2.draw();
  
  p3 = new Portico(x + story_width * 3, y, story_width, story_height, 3, col_width, layer_thickness, wall_hue, window_hue);
  p3.addRailing(layer_thickness*2, 10, layer_thickness * 2, railing_hue);
  p3.addArchWindows(35, 0, 10, 2, window_hue);
  p3.fillAll();
  p3.draw();
  
  p4 = new Portico(x, y + story_height * 1.5, story_width, story_height, 3, col_width, layer_thickness, wall_hue, window_hue);
  p4.addWindows(20, 0, 10, 5, window_hue);
  p4.fillAll();
  p4.draw();
  
  p5 = new Portico(x + story_width * 1.5, y + story_height * 1.5, story_width, story_height, 3, col_width, layer_thickness, wall_hue, window_hue);
  p5.addRailingTo(1, layer_thickness*2, 10, layer_thickness * 2, railing_hue);
  p5.addWindowTo(0, 20, 20, 20, 5, window_hue);
  p5.addWindowTo(2, 20, 20, 20, 5, window_hue);
  p5.fillAll();
  p5.draw();
  
  p6 = new Portico(x + story_width * 3, y + story_height * 1.5, story_width, story_height, 3, col_width, layer_thickness, wall_hue, window_hue);
  p6.addWindowTo(0, 20, 0, 20, 5, window_hue);
  p6.addArchWindowTo(1, 20, 0, 10, 5, window_hue);
  p6.addWindowTo(2, 20, 0, 20, 5, window_hue);
  p6.fillAll();
  p6.draw();
  
  p7 = new Portico(x, y + story_height * 3, story_width, story_height, 1, col_width * 1.5, layer_thickness, wall_hue, window_hue);
  p7.addWindows(20, 20, 80, 10, window_hue);
  p7.fillAll();
  p7.draw();
  
  p8 = new Portico (x + story_width * 1.5, y + story_height *3, story_width, story_height, 2, col_width, layer_thickness, wall_hue, window_hue);
  p8.addWindowTo(0, 20, 20, 30, 10, window_hue);
  p8.addWindowTo(1, 20, 0, 30, 10, window_hue);
  p8.fillAll();
  p8.draw();
  
  p9 = new Portico (x + story_width * 3, y + story_height *3, story_width, story_height, 2, col_width, layer_thickness, wall_hue, window_hue);
  p9.addArchWindows(20, 20, 30, 10, window_hue);
  p9.fillAll();
  p9.draw();
  
  porticos = new ArrayList<Portico>();
  porticos.add(p1);
  porticos.add(p2);
  porticos.add(p3);
  porticos.add(p4);
  porticos.add(p5);
  porticos.add(p6);
  porticos.add(p7);
  porticos.add(p8);
  porticos.add(p9);
}

void draw() {
  boolean draw = false;
  for (Portico port : porticos) {
    if (!port.isFilled())
      draw = true;
  }
  
  if (draw) {
    background(30);
    for (Portico port : porticos) {
      port.fillByLayer();
      port.draw(false, false, true);
    }
  }
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}

void keyPressed() {
  for (Portico port : porticos) {
    port.reset();
    background(30);
  }
}