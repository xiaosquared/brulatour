class Segment {
  PVector a;
  PVector b;
  
  Segment(PVector a, PVector b) {
    this.a = a;
    this.b = b;
    
  }

  float getMinX() { return min(a.x, b.x); }
  float getMaxX() { return max(a.x, b.x); }
  float getMinY() { return min(a.y, b.y); }
  float getMaxY() { return max(a.y, b.y); }

  float getSlope() {
    return (b.y - a.y) / (b.x - a.x);
  }

  // neg slope is tilted right, pos slope is tilt left
  boolean tiltRight() {
    return getSlope() < 0; 
  }
  
  boolean tiltLeft() {
    return getSlope() > 0;
  }
  
  void draw() {
    line(a.x, a.y, b.x, b.y);
  }
  
  void printInfo() {
    println("a " + a.x + ", " + a.y);
    println("b " + b.x + ", " + b.y);
    println("slope " + getSlope());
  }
}