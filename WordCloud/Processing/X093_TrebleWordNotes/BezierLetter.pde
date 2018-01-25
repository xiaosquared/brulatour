class BezierLetter {
  char letter;
  float size;
  boolean isVisible = true;
  
  PVector position;
  float angle;
  
  public BezierLetter(char letter, float size, float x, float y, float angle, boolean isVisible) {
    this.letter = letter;
    this.size = size;
    position = new PVector(x, y);
    this.angle = angle;
    this.isVisible = isVisible;
  }
  
  public BezierLetter(char letter, float size, float x, float y, float angle) {
    this(letter, size, x, y, angle, true);
  }
  public void setVisibility(boolean b) { isVisible = b; }
  public boolean isVisible() { return isVisible; }
  
  public void draw() {
    if (!isVisible)
      return;
    
    textSize(size);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    text(letter, 0, 0);
    popMatrix();
  }
}