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