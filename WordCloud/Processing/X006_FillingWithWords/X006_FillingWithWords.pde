// 2.15.16
//
// Fill with words
//
// Get unique words of the phrase, compute width (for default height)
// Then use randomized greedy algorithm to fill space with words
//
// 700 words looks pretty "filled", especially to the right 
// and is still fast. 800 starts slowing down. 900 takes a few seconds.

//String phrase = "We do not grow absolutely chronologically\n We grow sometimes in one dimension and not in another\n unevenly\n We grow partially\n We are relative\n We are mature in one realm childish in another\n The past present and future mingle and pull us backward forward or fix us in the present\n We are made up of layers cells constellations";
String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCarondolet Canal\nsugar\ntobacco\ncotton\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\ncypressStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nDowntown\nhurricane\nslavery\nReconstruction\nantibellum";
WordSet words;

PFont font;
int init_y = 50;
int default_font_size = 20;

ArrayList<Rectangle> bounding_boxes;

// width of box is between min & max times more than height
float min_ratio = 2.5;  
float max_ratio = 9; 
float max_width = 130;
float min_height = 4;

boolean pause = false;
int count = 0;
int max_count = 500;

void setup() {
  size(600, 600);
  stroke(200);
  noFill();
  
  font = createFont("American Typewriter", 60);
  textFont(font, default_font_size);
  textAlign(LEFT, TOP);
  
  background(50);
  
  words = new WordSet(default_font_size);
  processPhrase();
  
  bounding_boxes = new ArrayList<Rectangle>();
 
}
 
void processPhrase() {
  String[] words_raw = split(phrase, '\n');
  for (int i = 0; i < words_raw.length; i++) {
      String s = words_raw[i];
      if (!words.containsWord(s))
        words.addWord(s);
  }
  words.computeWidths();
  words.print();
}

void draw() {
  //drawWordsDebug();
  while (count < max_count) {
    addWord();
  } 
}

void addWord() {
  // pick a point not inside an existing rectangle
  PVector p = new PVector(random(0, width), random(0, height));
  while (insideBoundingBoxes(p)) { p = new PVector(random(0, width), random(0, height)); }
  
  // constrain width and height based on existing bounding boxes
  float ratio = random(min_ratio, max_ratio);
  float rWidth = min(max_width, width - p.x);
  float rHeight = min(rWidth / ratio, height - p.y);
  for (Rectangle r : bounding_boxes) {
    if ((r.getMinY() > p.y) && (r.getMaxX() > p.x)) 
      rHeight = min(rHeight, r.getMinY() - p.y);
    else if ((r.getMinX() > p.x) && (r.getMaxY() > p.y)) 
      rWidth = min(rWidth, r.getMinX() - p.x);
  }
  
  // Adjust based on ratio range of width & height
  if (rHeight > rWidth/min_ratio)
    rHeight = rWidth/ratio;
  if (rHeight < min_height)
    return;
  if (rHeight < rWidth/max_ratio)
    rWidth = rHeight * max_ratio;
  
  // pick a word & adjust width by ratio of selected word
  float current_ratio = rWidth/rHeight;
  //println("ratio: " + current_ratio);
  int index = words.pickWord(current_ratio);
  rWidth = rHeight * words.ratios[index];
  Rectangle box = words.drawWord(index, p.x, p.y, rWidth); 
  bounding_boxes.add(box);
  
  count++;
}

boolean insideBoundingBoxes(PVector p) {
  for (Rectangle r : bounding_boxes) {
    if (r.contains(p))
      return true;
  }
  return false;
}

void keyPressed() {
  println("Key Pressed: " + keyCode);
  if (keyCode == 32) {
    pause = !pause;
  }
  if (pause)
    println("Total rounds: " + count);
}

/********************/
/* Just for testing */
/********************/

void drawWordsDebug() {
  int word_y = init_y;
  for (int i = 0; i < words.num_words; i++) {
    Rectangle r = words.drawWord(i, 50, word_y, 100);
    word_y += r.height;
  }
}