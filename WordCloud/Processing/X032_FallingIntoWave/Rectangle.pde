class Rectangle extends Particle {
  float w;
  float h;
  float drag = 0;
  float d = 0.08;
  boolean inWater = false;
  
  Rectangle(float x, float y, float w, float h) {
    super(new PVector(x + w/2, y + h/2), new PVector(0, 15), new PVector(0, 0.5));
    this.w = w;
    this.h = h;
  }
  
  void update() {
    if (inWater) {
      drag = d * vel.y * vel.y;
      if (vel.y > 0) {
        drag = -drag;
      }
      acc.y = g + drag;  
    }
    vel.add(acc);
    pos.add(vel);
  }
  
  void run() {
    super.run();
  }
  
  void draw() {
    fill(150);
    rect(pos.x, pos.y, w, h);
  }
}