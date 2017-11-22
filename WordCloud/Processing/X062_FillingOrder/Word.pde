class Word {
  String text;
  float width_height_ratio;
  float default_font_size = 20;
  
  Word(String text) {
    this.text = text;
    
    // find width to height ratio
    textSize(default_font_size);
    width_height_ratio = textWidth(text)/default_font_size;
  }
  
  float getRatio() {
    return width_height_ratio;
  }
  
  void draw(int x, int y, float font_size) {
    textSize(font_size);
    text(text, x, y);
  }
}

class WordManager {
  ArrayList<Word> words;
  int num_words;
  
  public WordManager() {
    words = new ArrayList<Word>();
    num_words = 0;
  }
  
  Word getRandomWord() {
    int index = floor(random(num_words));
    return words.get(index);
  }
  
  void addWord(String text) {
    words.add(new Word(text));
    num_words++;
  }
  
  boolean containsWord(String str) {
    for (Word w : words) {
      if (w.text.equals(str))
        return true;
    }
    return false;
  }
  
  void addAllWords(String phrase) {
    String[] raw_words = split(phrase, '\n');
    for (int i = 0; i < raw_words.length; i++) {
      String str = raw_words[i];
      if (!words.contains(str)) {
        addWord(str);
      }
    }
  }
  
  float getMinWidth(float layer_height) {
    if (words.size() == 0) {
      return 0;
    }
    if (words.size() == 1) {
      return words.get(0).getRatio() * layer_height;
    } 
    else {
      float min_ratio = words.get(0).getRatio();
      for (int i = 0; i < words.size(); i++) {
        min_ratio = min(min_ratio, words.get(i).getRatio());
      }
      return min_ratio * layer_height;
    }
    
  }
  
  void print() {
    for (int i = 0; i < words.size(); i++) {
      Word w = words.get(i);
      println(w.text + " - width ratio " + w.width_height_ratio);
    }
  }
  
}