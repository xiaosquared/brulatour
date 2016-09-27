class Rectangle extends Particle {
  float w;
  float h;
  float d = 0;
  boolean inWater = false;
  
  Rectangle(float x, float y, float w, float h) {
    super(new PVector(x + w/2, y + h/2), new PVector(0, 15), new PVector(0, 0.5));
    this.w = w;
    this.h = h;
  }
  
  void update() {
    vel.add(acc);
    pos.add(vel);
    acc.y -= vel.y * vel.y * d;
    acc.y = max(acc.y, 0);
  }
  
  void run() {
    super.run();
  }
  
  void draw() {
    fill(150);
    rect(pos.x, pos.y, w, h);
  }
}