// 1.24.18
//
// Treble Word Notes
//
// Same as X091 but with a treble clef!
// A row of Word Notes pop on one by one to fill the staff 
// Then they pop off one by one 
//

SineStaff staff;
String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane";
String[] words = new String[20];
int font_size = 6;
PFont font;

float current_time;
float last_change_time = 0;
float CHANGE = 500;

void setup() {
  //size(1400, 800, P2D);
  fullScreen(P2D);
  background(0);

  initWords();
  
  staff = new SineStaff(new PVector(0, height*2/3), width - 100, 120, -PI/15);
  staff.initText(words, font_size);
  
  staff.fillWithWordNotes(200, 40);
  
  staff.update();
  staff.draw();
}

void draw() {
  background(0);
  staff.update();
  staff.draw();
  
  //clef.draw();
  
  current_time = millis();
  if (current_time - last_change_time > CHANGE) {
    if (!staff.addWordNote(40))
      staff.removeFirstWordNote();
    last_change_time = current_time;
  }
  
}

String getRandomWord() {
  int index = floor(random(words.length));
  return words[index];
}

void initWords() {
  words = split(phrase, '\n');
  font = createFont("American Typewriter", 40);
  textFont(font, font_size);
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}

void keyPressed() {
  
}