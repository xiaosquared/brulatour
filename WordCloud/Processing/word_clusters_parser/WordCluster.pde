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
    fill(c);
    
    Iterator<Word> it = words.iterator();
    while(it.hasNext()) {
      Word w = it.next();
      
      if (bAnimate)
        w.update();
  
      pushMatrix();
      translate(0, -100);
      scale(0.8);
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