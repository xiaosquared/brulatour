// 01.21.18
//
// Word Stems
// + Note Groups updated
// 
// Picks random word. Creates a note group from it
// Draws the word at the top

SineStaff staff;
WordNote wn;
NoteGroup ng;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane";
String[] words = new String[20];
int font_size = 6;
PFont font;

void setup() {
  size(1280, 800, P2D);
  background(0);
  
  initWords();
  
  staff = new SineStaff(new PVector(50, height*2/3), width - 100, 120, -PI/15);
  staff.initText(words, font_size);
  staff.update();
  staff.draw();
  
  String word = getRandomWord();
  wn = new WordNote(word, 20, 0);
  staff.addWordNote(wn);
  //ng = new NoteGroup(200, 300);
  //staff.addNoteGroup(ng);
}

void draw() {
  background(0);
  staff.update();
  staff.draw();
}

void initWords() {
  words = split(phrase, '\n');
  font = createFont("American Typewriter", 40);
  textFont(font, font_size);
}

String getRandomWord() {
  int index = floor(random(words.length));
  return words[index];
}

void mousePressed() {
  println(mouseX + " " + mouseY);
}

void keyPressed() {
  String word = getRandomWord();
  wn = new WordNote(word, 40, 0);
  staff.word_notes.clear();
  staff.addWordNote(wn);
  
  //staff.addRandomNote();
  //ng = new NoteGroup(random(100, 300), 0);
  //staff.note_groups.clear();
  //staff.addNoteGroup(ng);
}