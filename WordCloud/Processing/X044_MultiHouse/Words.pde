/* Contains:

- WordCluster
- Word
- Rectangle (used by Word)
- WordSet

*/

///////////////////////////////////////////////////////////////////////////////////////////////////

/*
  Last update: 3.12.16

  Abridged version of code since we're only worried about drawing from JSON 
  and not about generating the WordCluster.
  
  For original version, see words_as_house sketch
*/

class WordCluster {
  ArrayList<Word> words;
  int c = 200;
  
  WordCluster() {
    words = new ArrayList<Word>();
  }
  
  void setColor(int c) { this.c = c; }
  
  void draw() {
    draw(0, 0, 1);
  }
  
  void draw(float xTrans, float yTrans, float s) {
    fill(c);
    
    Iterator<Word> it = words.iterator();
    while(it.hasNext()) {
      Word w = it.next();
      
      pushMatrix();
      translate(xTrans, yTrans);
      scale(s);
      w.draw();
      popMatrix();
    }
  }

  void addWord(Word w) {
    words.add(w);
  }
  
  void clearWords() {
     words.clear();
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////


/*
  Last update: 10.26.16
*/

class Word {
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  int wordIndex;
  float fontHeight;
  float fontWidth;
  
  WordSet ws;
  
  Rectangle boundingBox;
  
  Word(int i, float s, PVector p , WordSet ws) {
    this.ws = ws;
    
    wordIndex = i;
    fontHeight = s;
    fontWidth = ws.getWidthFromHeight(i, fontHeight);
    position = p;
    velocity = new PVector(0, 0);
    
    boundingBox = new Rectangle(position.x, position.y, fontWidth, fontHeight);
  }
  
  Word(int i , float w, float h, PVector p, WordSet ws) {
    this.ws = ws;
    
    wordIndex = i;
    fontWidth = w;
    fontHeight = h;
    position = p;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
    boundingBox = new Rectangle(position.x, position.y, fontWidth, fontHeight);
  }
  Word(int i, WordSet ws) {
    this(i, 20, new PVector(0, 0), ws);
  }
  
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    if (position.x <= 0 || position.x + fontWidth > width)
      velocity.x = -velocity.x;
    if (position.y <=0 || position.y + fontHeight > height)
      velocity.y = -velocity.y;
  }
  
  boolean boxContains(PVector p) {
    return boundingBox.contains(p);
  }
  
  void draw() {
    String s = ws.getWord(wordIndex);
    textSize(fontHeight);
    text(s, position.x, position.y - (fontHeight * 0.1));
  }
  
  void draw(float wordWidth) {
    String s = ws.getWord(wordIndex);
    
    fontWidth = wordWidth;
    fontHeight = ws.getFontHeight(wordIndex, wordWidth);

    textSize(fontHeight);
    text(s, position.x, position.y - (fontHeight * 0.1));
  }
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////

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
  
  float getMinX() { return tl.x; }
  float getMinY() { return tl.y; }
  float getMaxX() { return tr.x; }
  float getMaxY() { return bl.y; }
  
  void setWidth(float w) {
    this.width = w;
    tr.x = tl.x + w;
    br.x = tr.x;
  }
  
  void setHeight(float h) {
    this.height = h;
    bl.y = tl.y + h;
    br.y = bl.y;
  }
  
  void draw() { rect(tl.x, tl.y, width, height); }
  
  boolean contains(PVector p) {
    return (p.x > tl.x) && (p.x < tr.x) && (p.y > tl.y) && (p.y < bl.y);
  }
  
  boolean contains(float x, float y) {
    return (x > tl.x) && (x < tr.x) && (y > tl.y) && (y < bl.y);
  }
  
  void printInfo() {
    println("Top Left: " + tl.x + ", " + tl.y);
    println("Top Right: " + tr.x + ", " + tr.y);
    println("Bottom Left: " + bl.x + ", " + bl.y);
    println("Bottom Right: " + br.x + ", " + br.y);
    println("width: " + width + ", height: " + height); 
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class WordSet {
  String[] words;
  float[] widths;  // width of each word, based on words drawn at defaultFontHeight
  float[] ratios;
  int numWords;
  int defaultFontHeight;

  WordSet(int fontSize) {
    numWords = 25;
    defaultFontHeight = fontSize;
    
    initWords();
    computeWidths();
  }
  
  String getWord(int index) {
    return words[index];
  }
  
  float getFontHeight(int index, float wordWidth) {
    if (index >= numWords)
      return 0;
    return wordWidth / widths[index] * defaultFontHeight;
  }
  
  float getWidthFromHeight(int index, float fontSize) {
    if (index >= numWords)
      return 0;
    return ratios[index] * fontSize;
  }
  
  int getRandomWordIndex(float maxRatio) {
    int i = floor(random(numWords));
    while(ratios[i] > maxRatio) { i = floor(random(numWords)); }
    return i;
  }
  
  int getRandomWordIndex() {
    return this.getRandomWordIndex(100);
  }
  
  void initWords() {
    words = new String[numWords];
    words[0] = "Vieux carré";
    words[1] = "Mardi Gras";
    words[2] = "Mississippi River";
    words[3] = "Lake Pontchartrain";
    words[4] = "War of 1812";
    words[5] = "St. Louis Cathedral";
    words[6] = "sugar";
    words[7] = "plantation";
    words[8] = "Congo Square";
    words[9] = "bamboula";
    words[10] = "Treme";
    words[11] = "Marigny";
    words[12] = "levee"; 
    words[13] = "Storyville";
    words[14] = "Louis Armstrong";
    words[15] = "Jelly-Roll Morton";
    words[16] = "Creole";
    words[17] = "Bayou St. John";
    words[18] = "Jean Lafitte";
    words[19] = "French Market";
    words[20] = "Uptown";
    words[21] = "hurricane";
    words[22] = "slavery";
    words[23] = "Reconstruction";
    words[24] = "antibellum";
  }
  
  void computeWidths() {
    textSize(defaultFontHeight);
    widths = new float[numWords];
    ratios = new float[numWords];
    for (int i = 0; i < widths.length; i++) {
      widths[i] = textWidth(words[i]);
      ratios[i] = widths[i] / defaultFontHeight;
    }
  }
  
  void print() {
    for (int i = 0; i < words.length; i++) {
      println(words[i] + " - ratio: " + ratios[i]);
    }
  }
}