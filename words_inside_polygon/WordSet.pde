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
  int pickWord(float max_ratio) {
    int i = floor(random(num_words));
    while(ratios[i] > max_ratio) { i = floor(random(num_words)); } 
    return i;
  }
  
  // draws word at index "i", scales it to the specified width, returns bounding rectangle
  void drawWord(int i, float x, float y, float specified_width) {
    String word = words.get(i);
    float specified_height = specified_width / widths[i] * 20;
    
    textSize(specified_height);
    text(word, x, y - (specified_height * 0.1));
    
    // bounding rectangle
    //Rectangle r = new Rectangle(x, y, specified_width, specified_height);
    //r.draw();
    //return r;
  }
  
  float getSpecifiedHeight(int i, float specified_width) {
    return specified_width / widths[i] * 20;
  }
  
  void computeWidths() {
    widths = new float[words.size()];
    ratios = new float[words.size()];
    for (int i = 0; i < widths.length; i++) {
      widths[i] = textWidth(words.get(i));
      ratios[i] = widths[i]/default_height;
    }
  }
  
  boolean containsWord(String word) {
    for (String s : words) {
      if (s.equals(word))
        return true;
    }
    return false;
  }

  void addWord(String word) { words.add(word); num_words++; }

  void print() {
    for (int i = 0; i < widths.length; i++) {
      println(words.get(i) + " - width ratio " + widths[i]/default_height);
    }
  }
  
}