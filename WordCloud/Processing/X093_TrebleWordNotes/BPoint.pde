class BPoint {
  PVector pt;
  boolean isAnchor;
  boolean isSelected = false;
    
  public BPoint(PVector pt, boolean isAnchor) {
    this.pt = pt;
    this.isAnchor = isAnchor;
  }
  public BPoint(float x, float y, boolean isAnchor) {
    this(new PVector(x, y), isAnchor);
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
  
  public void print() {
    if (isAnchor)
      System.out.print("Anchor: ");
    else
      System.out.print("Pt: ");
    println(pt.x + ", " + pt.y);
  }
}