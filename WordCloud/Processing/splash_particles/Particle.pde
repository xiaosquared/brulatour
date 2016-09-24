class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  
  Particle(PVector pos, PVector vel) {
    this.pos = pos;
    this.vel = vel;
    acc = new PVector(0, 0.2);
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
    ellipse(pos.x, pos.y, 2, 2);
  }
}