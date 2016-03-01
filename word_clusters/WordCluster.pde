class WordCluster {
  ArrayList<Word> words;
  
  // Add color!!
  // Add polygon
  
  WordCluster() {
    words = new ArrayList<Word>();
  }
  
  void populateRandomly(int numWords) {
    while (numWords > 0) {
      int index = ws.getRandomWordIndex();
      float size = random(4, 30);
      PVector position = new PVector(random(width-100), random(height-20));
      words.add(new Word(index, size, position));
      numWords--;
    }
  }
  
  void draw() {
    Iterator<Word> it = words.iterator();
    while(it.hasNext()) {
      Word w = it.next();
      w.update();
      w.draw();
    }
  }
}