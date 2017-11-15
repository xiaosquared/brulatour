// 11.13.17
//
// Fill Wall with Words
//
// Putting words into new filling algorithm!
// Right now all the words are the same height
//

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCarondolet Canal\nsugar\ntobacco\ncotton\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\ncypressStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nDowntown\nhurricane\nslavery\nReconstruction\nantibellum";
WordManager wm;

PFont font;
int default_font_size = 20;

Word word;

Trapezoid trapezoid;
float layer_height = 15;

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
                            new PVector(40, 600), new PVector(1120, 600), layer_height, min_brick_width);
  
  background(30);
}

void draw() {
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}

void keyPressed() {
  background(30);
  //trapezoid.addBrick(50, 250);
  word = wm.getRandomWord();
  println(word.text);
  trapezoid.addWordBrick(word);
  trapezoid.draw();
}