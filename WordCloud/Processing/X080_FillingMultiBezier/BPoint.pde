class BPoint {
  PVector pt;
  boolean isAnchor;
  boolean isSelected = false;
    
  public BPoint(float x, float y, boolean isAnchor) {
    pt = new PVector(x, y);
    this.isAnchor = isAnchor;
  }
 
  public float x() { return pt.x; }
  public float y() { return pt.y; }
  public boolean isSelected() { return isSelected; }
  public void setX(float x) { pt.x = x; }
  public void setY(float y) { pt.y = y; }
  public void setSelected(boolean s) { isSelected = s; }
    
  public void draw() {
    if (isSelected)
      strokeWeight(3);
    else
      strokeWeight(1);
    
    if (isAnchor)
      fill(255, 0, 0);
    else
      fill(0, 255, 0);
    ellipse(pt.x, pt.y, 10, 10);
  }
}