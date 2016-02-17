// 2.13.16
// 
// Filling a space with non-overlapping circles
// An experiment for the HNOC "Word Cloud" installation
//
// Algorithm from: http://paulbourke.net/texture_colour/randomtile/

// TODO:
// Take the recursion out of pointNotInCircles
// 

ArrayList<Circle> circles;

int minRadius = 5;
int maxRadius = 50;

void setup() {
  size(300, 300);
  
  circles = new ArrayList<Circle>();
 
}

void draw() {
  background(30);
  stroke(200);
  noFill();
  ellipseMode(RADIUS);
  
  for (Circle c : circles) {
    c.draw();
  }
  
  addCircle();
}

void addCircle() {
  PVector p = pointNotInCircles();
  float r = maxRadiusWithoutOverlap(p, maxRadius);
  
  if (r > minRadius) {
    circles.add(new Circle(p.x, p.y, r));
  }
}

void mousePressed() {
  addCircle();
}

/*
 * HELPER FUNCTIONS!
 */ 
PVector pointNotInCircles() {
  PVector p = new PVector(random(0, width), random(0, height));
  while (insideCircles(p)) {
    p = new PVector(random(0, width), random(0, height));
  }
  return p;
}

boolean insideCircles(PVector p) {
  for (Circle c : circles) {
    if (c.contains(p))
      return true;
  }
  return false;
}

float maxRadiusWithoutOverlap(PVector p, float maxRadius) {
  float radius = maxRadius;
  for (Circle c : circles) {
    float allowedRadius = dist(c.x, c.y, p.x, p.y) - c.r; 
    radius = min(allowedRadius, radius);
  }
  return radius;
}

class Circle {
  float x;
  float y;
  float r;
  
  Circle(float xcenter, float ycenter, float radius) {
    x = xcenter;
    y = ycenter;
    r = radius;
  }
  
  void draw() {
    ellipse(x, y, r, r);
  }
  
  boolean intersects(Circle c) {
    float centerDist = dist(x, y, c.x, c.y);
    return centerDist < r+c.r; 
  }
  
  boolean contains(PVector p) {
    return dist(x, y, p.x, p.y) < r;
  }
  
  void printInfo() {
    println("Center: " + x + ", " + y + ", Radius: " + r);
  }
}