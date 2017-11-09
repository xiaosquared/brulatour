import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class X006_FillingWithWords extends PApplet {

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
String phrase = "Vieux carr\u00e9\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCarondolet Canal\nsugar\ntobacco\ncotton\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\ncypressStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nDowntown\nhurricane\nslavery\nReconstruction\nantibellum";
WordSet words;

PFont font;
int init_y = 50;
int default_font_size = 20;

ArrayList<Rectangle> bounding_boxes;

// width of box is between min & max times more than height
float min_ratio = 2.5f;  
float max_ratio = 9; 
float max_width = 130;
float min_height = 4;

boolean pause = false;
int count = 0;
int max_count = 500;

public void setup() {
  
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
 
public void processPhrase() {
  String[] words_raw = split(phrase, '\n');
  for (int i = 0; i < words_raw.length; i++) {
      String s = words_raw[i];
      if (!words.containsWord(s))
        words.addWord(s);
  }
  words.computeWidths();
  words.print();
}

public void draw() {
  //drawWordsDebug();
  while (count < max_count) {
    addWord();
  } 
}

public void addWord() {
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

public boolean insideBoundingBoxes(PVector p) {
  for (Rectangle r : bounding_boxes) {
    if (r.contains(p))
      return true;
  }
  return false;
}

public void keyPressed() {
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

public void drawWordsDebug() {
  int word_y = init_y;
  for (int i = 0; i < words.num_words; i++) {
    Rectangle r = words.drawWord(i, 50, word_y, 100);
    word_y += r.height;
  }
}
class Rectangle {
  PVector tl;  // top left
  PVector tr;  // top right
  PVector bl;  // bottom left
  PVector br;  // bottom right
  float width;
  float height;
  
  Rectangle(float x, float y, float width, float height) {
    tl = new PVector(x, y);
    tr = new PVector(tl.x + width, tl.y);
    bl = new PVector(tl.x, tl.y + height);
    br = new PVector(tr.x, tr.y + height);
    this.width = width;
    this.height = height;
  }
  
  public float getMinX() { return tl.x; }
  public float getMinY() { return tl.y; }
  public float getMaxX() { return tr.x; }
  public float getMaxY() { return bl.y; }
  
  public void draw() { rect(tl.x, tl.y, width, height); }
  
  public boolean contains(PVector p) {
    return this.contains(p.x, p.y);
  }
  
  public boolean contains(float x, float y) {
    return (x > tl.x) && (x < tr.x) && (y > tl.y) && (y < bl.y);
  }
  
  public void printInfo() {
    println("Top Left: " + tl.x + ", " + tl.y);
    println("Top Right: " + tr.x + ", " + tr.y);
    println("Bottom Left: " + bl.x + ", " + bl.y);
    println("Bottom Right: " + br.x + ", " + br.y);
    println("width: " + width + ", height: " + height); 
  }
}
class WordSet {
  ArrayList<String> words;
  float[] widths;  // width of each word, based on words drawn at default_size
  float[] ratios;  // width/height
  int num_words;
  int default_height;
  
  WordSet(int default_height) {
    words = new ArrayList<String>();  
    num_words = 0;
    this.default_height = default_height;
  }
  
  // @return index of random word
  public int pickWord(float max_ratio) {
    int i = floor(random(num_words));
    while(ratios[i] > max_ratio) { i = floor(random(num_words)); } 
    return i;
  }
  
  // draws word at index "i", scales it to the specified width, returns bounding rectangle
  public Rectangle drawWord(int i, float x, float y, float specified_width) {
    String word = words.get(i);
    float specified_height = specified_width / widths[i] * 20;
    
    textSize(specified_height);
    text(word, x, y - (specified_height * 0.1f));
    
    // bounding rectangle
    Rectangle r = new Rectangle(x, y, specified_width, specified_height);
    //r.draw();
    return r;
  }
  
  public void computeWidths() {
    widths = new float[words.size()];
    ratios = new float[words.size()];
    for (int i = 0; i < widths.length; i++) {
      widths[i] = textWidth(words.get(i));
      ratios[i] = widths[i]/default_height;
    }
  }
  
  public boolean containsWord(String word) {
    for (String s : words) {
      if (s.equals(word))
        return true;
    }
    return false;
  }

  public void addWord(String word) { words.add(word); num_words++; }

  public void print() {
    for (int i = 0; i < widths.length; i++) {
      println(words.get(i) + " - width ratio " + widths[i]/default_height);
    }
  }
  
}
  public void settings() {  size(600, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "X006_FillingWithWords" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
