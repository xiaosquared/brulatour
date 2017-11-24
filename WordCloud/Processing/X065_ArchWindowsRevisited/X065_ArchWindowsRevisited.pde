// 11.23.17
//
// Roof
//
// Trapezoidal roof
//

Story story;
float x = 50;
float y = 50;
float width = 600;
float height = 200;
float layer_thickness = 10;

Roof roof;

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
  
  story = new Story(x, y+height, width, height, layer_thickness, 50);
  story.addArchWindows(3, 30, 40, 30, 50, 15, 100);
  //story.fillAll();
  story.draw();

  roof = new Roof(x-20, y, width+40, height, layer_thickness, 200);
  //roof.fillAll();
  //roof.draw(false, true, true);
  
  //ArchWindow aw = new ArchWindow(x, y, 70, 150, layer_thickness, 20);
  //aw.draw();
  
}

void draw() {
  //background(30);
  //story.fillByLayer();
  //story.draw();
  //roof.draw(false, false, true);
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