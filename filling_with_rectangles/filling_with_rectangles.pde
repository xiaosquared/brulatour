// 2.14.16
//
// Filling a space with non-overlapping rectangles with randomized greedy algorithm
//

Rectangle r;
Rectangle myRect;

ArrayList<Rectangle> rectangles;

// width of box is between min & max times more than height
float min_ratio = 2;  
float max_ratio = 8;

float max_width = 100;
float min_height = 4;

void setup() {
  size(400, 400);
  background(50);
  stroke(200);
  noFill();
  
  rectangles = new ArrayList<Rectangle>();
}

void draw() {
  addRectangle();
}

void addRectangle() {
  // Pick a point not inside an existing rectangle
  PVector p = new PVector(random(0, width), random(0, height));
  while (insideRectangles(p)) {
   p = new PVector(random(0, width), random(0, height));
  }
  
  // Constrain width and height based on existing rectangles
  float rWidth = min(max_width, width - p.x);
  float rHeight = min(rWidth / min_ratio, height - p.y);
  for (Rectangle r : rectangles) {
    if ((r.getMinY() > p.y) && (r.getMaxX() > p.x)) 
      rHeight = min(rHeight, r.getMinY() - p.y);
    else if ((r.getMinX() > p.x) && (r.getMaxY() > p.y)) 
      rWidth = min(rWidth, r.getMinX() - p.x);
  }
  
  // Adjust based on ratio range of width & height
  if (rHeight > rWidth/min_ratio)
    rHeight = rWidth/random(min_ratio, max_ratio);
  if (rHeight < min_height)
    return;
  if (rHeight < rWidth/max_ratio)
    rWidth = rHeight * max_ratio;
  
  // Add new rectangle
  Rectangle myRect = new Rectangle(p.x, p.y, rWidth, rHeight);
  rectangles.add(myRect);
  myRect.draw();
}

boolean insideRectangles(PVector p) {
  for (Rectangle r : rectangles) {
    if (r.contains(p))
      return true;
  }
  return false;
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
  println(insideRectangles(new PVector(mouseX, mouseY))); 
}

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
    println("Top Left: " + tl.x + ", " + tl.y);
    println("Top Right: " + tr.x + ", " + tr.y);
    println("Bottom Left: " + bl.x + ", " + bl.y);
    println("Bottom Right: " + br.x + ", " + br.y);
    println("width: " + width + ", height: " + height); 
  }
}