// 3.12.16
//
// Noise Test Multi
//
// A bunch of circles wobble from noise function

ArrayList<Circle> circles;
ArrayList<PVector> offsets;
int r = 50;
int numCircles = 20;

float xoff = 0;
float yoff = 100;
int nScale = 20;

void setup() {
  size(600, 600);
  
  circles = new ArrayList<Circle>();
  offsets = new ArrayList<PVector>();
  
  populateCircles(numCircles);
}

void draw() {
  background(50);
  
  for (int i = 0; i < numCircles; i++) {
    PVector nSeed = offsets.get(i);
    float nx = map(noise(nSeed.x), 0, 1, -nScale, nScale);
    float ny = map(noise(nSeed.y), 0, 1, -nScale, nScale);
  
    Circle c = circles.get(i);
    c.draw(nx, ny);
    
    nSeed.x += 0.01;
    nSeed.y += 0.01;
  }
}

void populateCircles(int number) {
  while (number > 0) {
    PVector p = pointNotInCircles();
    float maxR = maxRadiusWithoutOverlap(p, r);
  
    if (r == maxR) {
      circles.add(new Circle(p.x, p.y, r));
      offsets.add(new PVector(random(width), random(height)));
      number--;
    }
  }
}

PVector pointNotInCircles() {
  PVector p = new PVector(random(r, width-r), random(r, height-r));
  while (insideCircles(p)) {
    p = new PVector(random(r, width-r), random(r, height-r));
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
  
  void draw(float xoff, float yoff) {
    ellipse(x+xoff, y+yoff, r, r);
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