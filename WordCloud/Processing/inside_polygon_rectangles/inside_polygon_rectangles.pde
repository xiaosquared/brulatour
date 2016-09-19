// 2.16.16
//
// Fill an arbitrary convex polygon with rectangles!

Polygon poly;
RectCloud rects;

float min_ratio = 2;  
float max_ratio = 8;
float max_width = 100;
float min_height = 4;

void setup() {
  size(600, 600);
  noFill();
  stroke(200);
  background(50);
    
  poly = new Polygon();
  poly.addDefaultVertices();
  poly.computeBoundingBox();
  poly.printInfo();

  rects = new RectCloud();
}

void draw() {
  poly.draw();
  //poly.drawSegment(0, 1);
  //addRectangle();
}

void addRectangle(PVector p) {
  // pick a point inside polygon not in rectangles
  //PVector p = pickPoint(poly, rects);
  
  float r_width = width - p.x;
  float r_height = height - p.y;
  
  //Constrain width & height based on existing rectangles
  for (Rectangle r : rects.bounding_boxes) {
    if ((r.getMinY() > p.y) && (r.getMaxX() > p.x)) 
      r_height= min(r_height, r.getMinY() - p.y);
    else if ((r.getMinX() > p.x) && (r.getMaxY() > p.y)) 
      r_width = min(r_width, r.getMinX() - p.x);
  }
  
  // Adjust based on ratio range of width & height
  if (r_height > r_width/min_ratio)
    r_height = r_width/random(min_ratio, max_ratio);
  if (r_height < min_height)
    return;
  if (r_height < r_width/max_ratio)
    r_width = r_height * max_ratio;
  
  // Based on the polygon outline, first constrain the horizontal dimension
  for (int i = 0; i < poly.num_segments; i++) {
    Segment s = poly.getSegment(i);
    
    float h_dist = Utils.distPointSegmentHorizontal(p, s.a, s.b);
    if (h_dist > 0) r_width = min(r_width, h_dist);
  }
  
 
  
  
  Rectangle r = new Rectangle(p.x, p.y, r_width, r_height);
  rects.add(r);
  r.draw();
}


PVector pickPoint(Polygon poly, RectCloud rects) {
  PVector p = poly.getRandomPointInBoundingBox();
  
  while (!poly.contains(p) || rects.contains(p))
  p = poly.getRandomPointInBoundingBox();
  
  return p;
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
  addRectangle(new PVector(mouseX, mouseY));
  
}

void keyPressed() {
  if (keyCode == 32) {
    background(50);
    
  }
}