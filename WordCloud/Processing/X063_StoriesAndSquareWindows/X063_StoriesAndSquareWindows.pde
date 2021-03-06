// 11.21.17
//
// Stories and Square Windows
//
// Fixed a bug where words sometimes overlap!!!
// LOL a normal rectangular window is just a wall ahahah
//
// 11.22.17
//
// Story is a level with windows. Segments wall into two parts so words at the bottom 
// don't collide with words in window
//
// l, o, w - toggles drawing layers, outlines, words
// any other key resets what we're drawing and fills the whole thing at once 
//

Story story;
float x = 100;
float y = 100;
float width = 600;
float height = 300;
float layer_thickness = 6;

Wall win;

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
  //float min_brick_width = wm.getMinWidth(layer_thickness);
  
  story = new Story(x, y, x+width, y+height, layer_thickness, 50);
  story.addWindows(3, 40, 60, 50, 70, 10, 100);
  //story.fillAll();
  story.draw();

}

void draw() {
  background(30);
  story.fillByLayer();
  story.draw();
}

void keyPressed() {
  switch(key) {
    case 'l':
      story.draw_layers = !story.draw_layers;
      story.draw();
    break;
    
    case 'o':
      story.draw_outline = !story.draw_outline;
      story.draw();
    break;
    
    case 'w':
      story.draw_words = !story.draw_words;
      story.draw();
    break;
    default:
      background(30);
      story.reset();
      story.fillAll();
      story.draw();
      break;
  }
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}