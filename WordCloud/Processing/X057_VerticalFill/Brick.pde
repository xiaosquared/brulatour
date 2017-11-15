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

  Rectangle(PVector tl, PVector br) {
    println(tl.x + ", " + tl.y);
    println(br.x + ", " + br.y);
    this.tl = tl;
    this.tr = new PVector(br.x, tl.y);
    this.bl = new PVector(tl.x, br.y);
    this.br = br;
    
    this.width = br.x - tl.x;
    this.height = br.y - tl.y;
  }

  float getMinX() { return tl.x; }
  float getMinY() { return tl.y; }
  float getMaxX() { return tr.x; }
  float getMaxY() { return bl.y; }

  void draw() {
    rect(tl.x, tl.y, width, height); 
  }

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

class Brick extends Rectangle {
  Word word;
  int fill_color = 200;
  boolean isVertical = false;
  
  Brick(float x, float y, float width, float height, Word word, boolean isVertical) {
    super(x, y, width, height);
    this.word = word;
    this.isVertical = isVertical;
  }
  
  float getLowerBound() {
    return isVertical ? getMinY() : getMinX();
  }
  
  float getUpperBound() {
    return isVertical ? getMinY() + width : getMinX() + width;
  }
  
  void draw(boolean draw_border) {
    
    if (draw_border) {
      if (isVertical) {
        pushMatrix();
        translate(getMinX() + height, super.getMinY());
        rect(0, 0, height, width);
        rotate(HALF_PI);   
        popMatrix();
      } else
        super.draw();
    }
    fill(fill_color);
    word.draw(getMinX(), getMinY(), height, isVertical);
  }
  
  void growHeight(float new_height) {
    println("new height " + new_height);
    height = new_height;
    tl.y = br.y - new_height;
    tr.y = tl.y;
  }
}