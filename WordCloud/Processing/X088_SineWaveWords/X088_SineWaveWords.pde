// 01.19.18
//
// Sine Wave Words
//
// Filling a single random sine wave with words
// This is a step toward filling the entire staff lines with words
//

SineWave sw;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane";
String[] words = new String[20];
int font_size = 6;
PFont font;

void setup() {
  size(1200, 600);
  background(0);
  
  initWords();
  
  sw = new SineWave(new PVector(50, height/2), width - 100);
  sw.initText(words, font_size);
  sw.draw();
}

void draw() {
  background(0);
  sw.update();
  sw.draw();
}

void initWords() {
  words = split(phrase, '\n');
  font = createFont("American Typewriter", font_size);
  textFont(font, font_size);
}

void mousePressed() {
  println(mouseX + " " + mouseY);
}

void keyPressed() {
  println("keypressed");
  background(0);
  sw.update();
  sw.draw();
}