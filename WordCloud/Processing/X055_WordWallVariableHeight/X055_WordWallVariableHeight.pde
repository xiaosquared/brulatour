// 11.13.17
//
// Fill Wall with Words
//
// Putting words into new filling algorithm!
// Try putting a "featured word" (bigger)
// if fail, put random word in. Next time try again to put the featured word


String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCarondolet Canal\nsugar\ntobacco\ncotton\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\ncypress\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nDowntown\nhurricane\nslavery\nReconstruction\nantibellum";
WordManager wm;

PFont font;
int default_font_size = 20;

Word word;
boolean success = true;

Trapezoid trapezoid;
float layer_height = 10;

void setup() {
  size(1200, 800);
  stroke(200);
  textAlign(LEFT, TOP);
  
  font = createFont("American Typewriter", 60);
  textFont(font, default_font_size);

  wm = new WordManager();
  wm.addAllWords(phrase);
  float min_brick_width = wm.getMinWidth(layer_height);
  
  trapezoid = new Trapezoid(new PVector(400, 100), new PVector(700, 100), 
                            new PVector(40, 600), new PVector(1120, 600), 
                            layer_height, min_brick_width, 5);
  
  background(30);
}

void draw() {
  background(30);
  
  if (success)
    word = wm.getRandomWord();
  
  success = trapezoid.addWordBrick(word, true);
  
  if (! success) {
    trapezoid.addWordBrick(wm.getRandomWord(), false);
  }
    
  trapezoid.draw();
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}

void keyPressed() {
  background(30);
  
  
}