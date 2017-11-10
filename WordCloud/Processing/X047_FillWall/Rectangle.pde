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

  void draw() { rect(tl.x, tl.y, width, height); }

  boolean contains(PVector p) {
    return this.contains(p.x, p.y);
  }

  boolean contains(float x, float y) {
    return (x > tl.x) && (x < tr.x) && (y > tl.y) && (y < bl.y);
  }

  void printInfo() {
    System.out.println("Top Left: " + tl.x + ", " + tl.y);
    System.out.println("Top Right: " + tr.x + ", " + tr.y);
    System.out.println("Bottom Left: " + bl.x + ", " + bl.y);
    System.out.println("Bottom Right: " + br.x + ", " + br.y);
    System.out.println("width: " + width + ", height: " + height); 
  }
}