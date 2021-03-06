// 01.21.18
//
// Stemmed Notes
// + Note Groups
// 
// Generates notes to span a length betweeen 100 & 300
// If more than one note, connect the stems 
//

SineStaff staff;
NoteGroup ng;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane";
String[] words = new String[20];
int font_size = 6;
PFont font;

void setup() {
  size(1200, 600, P2D);
  background(0);
  
  initWords();
  
  staff = new SineStaff(new PVector(50, height*2/3), width - 100, 120, -PI/15);
  staff.initText(words, font_size);
  staff.update();
  staff.draw();
  
  ng = new NoteGroup(200, 300);
  staff.addNoteGroup(ng);
}

void draw() {
  background(0);
  staff.update();
  staff.draw();
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
  //staff.addRandomNote();
  ng = new NoteGroup(random(100, 300), 0);
  staff.note_groups.clear();
  staff.addNoteGroup(ng);
}