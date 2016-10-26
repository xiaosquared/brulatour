class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  float rad;
  
  Particle(PVector pos, PVector vel, float r) {
    this.pos = pos;
    this.vel = vel;
    acc = new PVector(0, 0.2);
    rad = r;
  }

  void run() {
    update();
    draw();
  }
  
  void update() {
    vel.add(acc);
    pos.add(vel);
  }

  void draw() {
    ellipse(pos.x, pos.y, rad*2, rad*2);
  }
  
  boolean isDead() {
    return pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height;
  }
}