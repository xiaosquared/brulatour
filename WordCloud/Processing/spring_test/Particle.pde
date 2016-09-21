class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  int diameter = 30;
  
  float K = 0.025;
  int TARGET_HEIGHT = 300;
  float DAMPING = 0.04;
  
  Particle(PVector p) {
    pos = p;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }

  void update() {
    float dist_y = TARGET_HEIGHT - getSpringHeight();
    acc.y = (-K * dist_y) - (DAMPING * vel.y);
    
    pos.add(vel);
    vel.add(acc);
  }
  
  void draw() {
    line(pos.x, pos.y, pos.x, height);
    ellipse(pos.x, pos.y, diameter, diameter);
  }
  
  boolean insideParticle(int x, int y) {
    return dist(x, y, pos.x, pos.y) < (float)diameter/2;
  }
  
  // helper functions
  float getSpringHeight() {
    return (float) height - pos.y;
  }
}