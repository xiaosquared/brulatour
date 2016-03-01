class Word {
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  int wordIndex;
  float fontHeight;
  float fontWidth;
  
  Word(int i, float s, PVector p) {
    wordIndex = i;
    fontHeight = s;
    fontWidth = ws.getWidthFromHeight(i, fontHeight);
    position = p;
    velocity = new PVector(random(-2, 2), random(-2, 2));
  }
  
  Word(int i) {
    this(i, 20, new PVector(0, 0));
  }
  
  void update() {
    position.add(velocity);
    if (position.x <= 0 || position.x + fontWidth > width)
      velocity.x = -velocity.x;
    if (position.y <=0 || position.y + fontHeight > height)
      velocity.y = -velocity.y;
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