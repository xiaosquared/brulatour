class Segment {
  PVector a;
  PVector b;
  float slope;  // neg slope is tilted right, pos slope is tilt left
  
  Segment(PVector a, PVector b) {
    this.a = a;
    this.b = b;
    
    slope = (b.y - a.y) / (b.x - a.x);
  }

  boolean tiltRight() {
    return slope < 0; 
  }
  
  boolean tiltLeft() {
    return slope > 0;
  }
  
  void draw() {
    line(a.x, a.y, b.x, b.y);
  }
}