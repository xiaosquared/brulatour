class Word {
  PVector p;
  String s;
  
  Word(PVector p, String s) {
    this.p = p;
    this.s = s;
  }
  
  void setPosition(float x, float y) {
    p.x = x;
    p.y = y;
  }
  
  void draw(float specified_height) {
    textSize(specified_height);
    text(s, p.x, p.y);
  }
}