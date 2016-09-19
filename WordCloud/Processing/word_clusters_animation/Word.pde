/*
  Last update: 3.13.16
*/

class State {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float fontSize;
  
  State(PVector p, float s) {
    position = p;
    fontSize = s;
  }
}

class Word {
  State startState;
  State targetState;

  PVector position;
  PVector velocity;
  PVector acceleration;
  
  int wordIndex;
  float fontHeight;
  float fontWidth;
  Rectangle boundingBox;
  
  WordCluster parent;
  
  Word(WordCluster wc, int i, float s, PVector p) {
    parent = wc;
    wordIndex = i;
    fontHeight = s;
    fontWidth = ws.getWidthFromHeight(i, fontHeight);
    position = p;
    velocity = new PVector(random(-2, 2), random(-2, 2));

    startState = new State(position, fontHeight);
    targetState = new State(ws.getGridPosition(wordIndex), ws.getGridModeHeight());
    
    
    boundingBox = new Rectangle(position.x, position.y, fontWidth, fontHeight);
  }
  
  Word(WordCluster wc, int i , float w, float h, PVector p) {
    parent = wc;
    wordIndex = i;
    fontWidth = w;
    fontHeight = h;
    position = p;
    velocity = new PVector(random(-2, 2), random(-2, 2));
    acceleration = new PVector(0, 0);
  
    startState = new State(position, fontHeight);
    targetState = new State(ws.getGridPosition(wordIndex), ws.getGridModeHeight());
    
    boundingBox = new Rectangle(position.x, position.y, fontWidth, fontHeight);
  }
  
  Word(WordCluster wc, int i) {
    this(wc, i, 20, new PVector(0, 0));
  }
  
  boolean boxContains(PVector p) {
    return boundingBox.contains(p);
  }
  
  void draw() {
    String word = ws.getWord(wordIndex);
    
    float fader = (float) mouseY/ (float) height;
    
    float fontSize = lerp(startState.fontSize, targetState.fontSize, fader);
    float x = lerp(startState.position.x, targetState.position.x, fader);
    float y = lerp(startState.position.y, targetState.position.y, fader);
    float c = lerp(parent.c, 170, fader);
    
    fill(c);
    textSize(fontSize);
    text(word, x, y - (fontSize * 0.1));
  }
  
  void draw(float wordWidth) {
    String s = ws.getWord(wordIndex);
    
    fontWidth = wordWidth;
    fontHeight = ws.getFontHeight(wordIndex, wordWidth);

    textSize(fontHeight);
    text(s, position.x, position.y - (fontHeight * 0.1));
  }
  
}