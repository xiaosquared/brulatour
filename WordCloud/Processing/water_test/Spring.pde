class Spring {
  PVector pos;
  PVector vel;
  PVector acc;
  int diameter = 30;
  
  float K = 0.025;
  float TARGET_HEIGHT;
  float DAMPING = 0.04;
  
  Spring(PVector p, int radius) {
    pos = p;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
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
    line(pos.x, pos.y, pos.x, height);
    ellipse(pos.x, pos.y, diameter, diameter);
  }

  boolean insideParticle(int x, int y) {
    return dist(x, y, pos.x, pos.y) < (float)diameter*2;
  }
  
  void perturb() {
    pos.y += random(-20, 20);
  }
  
  // helper functions
  float getSpringHeight() {
    return pos.y;
  }
}