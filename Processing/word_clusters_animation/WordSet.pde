class WordSet {
  String[] words;
  float[] widths;  // width of each word, based on words drawn at defaultFontHeight
  float[] ratios;
  int numWords;
  int defaultFontHeight;

  PVector[] gridPositions;
  PVector gridOrigin = new PVector(180, 120);
  int cellWidth = 250;
  int cellHeight = 175;
  float gridModeHeight = 20;

  WordSet(int fontSize) {
    numWords = 25;
    defaultFontHeight = fontSize;
    
    initWords();
    computeWidths();
    computeGridPositions();
  }
  
  String getWord(int index) {
    return words[index];
  }
  
  PVector getGridPosition(int index) {
    return gridPositions[index];
  }
  
  float getGridModeHeight() { return gridModeHeight; }
  
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
  
  void computeGridPositions() {
    gridPositions = new PVector[numWords];
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        float grid_x = gridOrigin.x + i * cellWidth;
        float grid_y = gridOrigin.y + j * cellHeight;
        
        gridPositions[(i*5)+j] = new PVector(grid_x, grid_y);
      }
    }
  }
  
  void print() {
    for (int i = 0; i < words.length; i++) {
      println(words[i] + " - ratio: " + ratios[i]);
    }
  }
}