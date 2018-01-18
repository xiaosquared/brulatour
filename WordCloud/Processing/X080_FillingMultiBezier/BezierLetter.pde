class BezierLetter {
  char letter;
  float size;
  
  PVector position;
  float angle;
  
  public BezierLetter(char letter, float size, float x, float y, float angle) {
    this.letter = letter;
    this.size = size;
    position = new PVector(x, y);
    this.angle = angle;
  }
  
  public void draw() {
    textSize(size);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    text(letter, 0, 0);
    popMatrix();
  }
}