class Spring {
  PVector pos;
  PVector vel;
  PVector acc;
  float radius;
  float diameter = 30;
  
  float K = 0.025;
  float TARGET_HEIGHT;
  float DAMPING = 0.04;

  Spring(PVector p, float r) {
    pos = p;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    radius = r;
    diameter = radius * 2;
    TARGET_HEIGHT = pos.y;
  }

  void update() {
    float dist_y = pos.y - TARGET_HEIGHT;
    acc.y = (-K * dist_y) - (DAMPING * vel.y);
    
    pos.add(vel);
    vel.add(acc);
  }
  
  void draw() {
    ellipse(pos.x, pos.y, radius, radius);
  }

  // true when x is on the same verical line as particle
  boolean pullingParticle(int x, int y) {
    return (abs(pos.x - x) < diameter) && (abs(y - TARGET_HEIGHT) < 40);
  }
  
  void perturb() {
    Ani.to(this.pos, 0.1, "y", random(TARGET_HEIGHT-50, TARGET_HEIGHT+50));
  }
  
  // helper functions
  float getSpringHeight() {
    return pos.y;
  }
}