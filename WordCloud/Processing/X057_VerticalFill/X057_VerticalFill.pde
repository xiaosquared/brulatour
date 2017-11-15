// 11.14.17
//
// Vertical Fill
//
// filling vertical blocks with words to create poles 
// A Stanchion is a vertical block... but I hate how it sounds
// Need to find a better naming scheme for my classes!!! 
//

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCarondolet Canal\nsugar\ntobacco\ncotton\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\ncypress\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nDowntown\nhurricane\nslavery\nReconstruction\nantibellum";
WordManager wm;
Word word;
float min_brick_width;

PFont font;
int default_font_size = 20;

float layer_height = 10;

ArrayList<Stanchion> poles;
int current_pole_index = 0;
boolean isFilled;


boolean success = true;

void setup() {
  size(1200, 800);
  stroke(200);
  fill(200);
  textAlign(LEFT, TOP);
  
  font = createFont("American Typewriter", 60);
  textFont(font, default_font_size);
  
  wm = new WordManager();
  wm.addAllWords(phrase);
  float min_brick_width = wm.getMinWidth(layer_height);
  
  poles = new ArrayList<Stanchion>();
  for (int i = 100; i < width - 50; i+= 100) {
    Stanchion s = new Stanchion(i, 50, 30, 700, layer_height, min_brick_width, 4);
    poles.add(s);
  }

}

void draw() {
  background(30);
  
  if (!isFilled) {
    Stanchion current_pole = poles.get(current_pole_index);
  
    if (success)
      word = wm.getRandomWord();
    
    success = current_pole.addWordBrick(word, true);
  
    if (! success) {
      current_pole.addWordBrick(wm.getRandomWord(), false);
    }
  
    if (current_pole.isFilled) {
      current_pole_index++;
      if (current_pole_index == poles.size())
        isFilled = true;
    }
  }
  
  for (Stanchion s : poles) {
    s.draw();
  }
  //if (success)
  //  word = wm.getRandomWord();
    
  //success = s.addWordBrick(word, true);
  
  //if (! success) {
  //  s.addWordBrick(wm.getRandomWord(), false);
  //}
  
  //s.draw();
}

void keyPressed() {
  
}