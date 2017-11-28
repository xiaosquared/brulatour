// 11.28.17
//
// Story with Balcony
//

Story story;
float story_width = 400;
float story_height = 300;
float layer_thickness = 6;
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
  
  float x = width/2 - story_width/2;
  float y = height/2 - story_height/2;
  story = new Story(x, y, story_width, story_height, layer_thickness, wall_hue);
  story.addRailing(12, 5, 12, railing_hue);
  story.addWindows(3, 30, 0, 50, 50, 5, window_hue);
}

void draw() {
  if (!story.isFilled()) {
    background(30);
    story.fillByLayer();
    story.draw(false, false, true);
  }
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}

void keyPressed() {
  if (key == 32)
    story.reset();
  if (key == 'f') {
    story.fillAll();
    story.draw(false, false, true);
  }
}