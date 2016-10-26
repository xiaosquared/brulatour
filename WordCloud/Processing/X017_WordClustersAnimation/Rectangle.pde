class Rectangle {
  PVector tl;  // top left
  PVector tr;  // top right
  PVector bl;  // bottom left
  PVector br;  // bottom right
  float width;
  float height;
  
  Rectangle(float x, float y, float width, float height) {
    tl = new PVector(x, y);
    tr = new PVector(tl.x + width, tl.y);
    bl = new PVector(tl.x, tl.y + height);
    br = new PVector(tr.x, tr.y + height);
    this.width = width;
    this.height = height;
  }
  
  float getMinX() { return tl.x; }
  float getMinY() { return tl.y; }
  float getMaxX() { return tr.x; }
  float getMaxY() { return bl.y; }
  
  void setWidth(float w) {
    this.width = w;
    tr.x = tl.x + w;
    br.x = tr.x;
  }
  
  void setHeight(float h) {
    this.height = h;
    bl.y = tl.y + h;
    br.y = bl.y;
  }
  
  void draw() { rect(tl.x, tl.y, width, height); }
  
  boolean contains(PVector p) {
    return (p.x > tl.x) && (p.x < tr.x) && (p.y > tl.y) && (p.y < bl.y);
  }
  
  boolean contains(float x, float y) {
    return (x > tl.x) && (x < tr.x) && (y > tl.y) && (y < bl.y);
  }
  
  void printInfo() {
    println("Top Left: " + tl.x + ", " + tl.y);
    println("Top Right: " + tr.x + ", " + tr.y);
    println("Bottom Left: " + bl.x + ", " + bl.y);
    println("Bottom Right: " + br.x + ", " + br.y);
    println("width: " + width + ", height: " + height); 
  }
}