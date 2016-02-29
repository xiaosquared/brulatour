// 2.27.16
//
// Random positions test
//
// Interpolates between 25 words in a 5x5 grid and in random positions
// based on x position of the mouse

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nsugar\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane\nslavery\nReconstruction\nantibellum";
Word[] words = new Word[25];

PFont font;
int default_font_size = 14;

int grid_width = 5;
int cell_width = 150;
int cell_height = 150;
PVector grid_origin = new PVector(100, 75);

int seed = 0;
int boundary = 200;

void setup() {
  size(800, 800);
  stroke(200);
  noFill();
  
  font = createFont("American Typewriter", 60);
  textFont(font, default_font_size);
  textAlign(CENTER, CENTER);
 
  processPhrase();
}

void processPhrase() {
  String[] words_raw = split(phrase, '\n');
  println("How Many Words: " + words_raw.length);
  
  for (int i = 0; i < words_raw.length; i++) {
    String s = words_raw[i];
    Word w = new Word(new PVector(20, i * 25), s);
    words[i] = w;
  }
}

void draw() {
  background(50);
  
  float fader = (float) mouseX/width;
  
  randomSeed(seed);
  for (int i = 0; i < grid_width; i++) {
    for (int j = 0; j < grid_width; j++) {
        float grid_x = grid_origin.x + i * cell_width;
        float grid_y = grid_origin.y + j * cell_height;
        
        float random_x = random(boundary, width-boundary);
        float random_y = random(boundary, height-boundary);
        float random_size = random(8, 40);
        
        float x = lerp(grid_x, random_x, fader);
        float y = lerp(grid_y, random_y, fader);
        float font_size = lerp(default_font_size, random_size, fader);
        
        int index = i * grid_width + j;
        words[index].setPosition(x, y); 
        words[index].draw(font_size);        
    }
  }
  
}