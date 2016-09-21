class Spring {
  PVector pos;
  PVector vel;
  PVector acc;
  int diameter = 30;
  
  float K = 0.025;
  float TARGET_HEIGHT;
  float DAMPING = 0.04;
  
  String word;
  float word_offset;
  
  Spring(PVector p, int radius, String w, float wo) {
    pos = p;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    diameter = radius * 2;
    TARGET_HEIGHT = pos.y;
    
    word = w;
    word_offset = wo;
  }

  void update() {
    float dist_y = pos.y - TARGET_HEIGHT;
    acc.y = (-K * dist_y) - (DAMPING * vel.y);
    
    pos.add(vel);
    vel.add(acc);
  }
  
  void draw() {
    draw(true);
  }
  
  void draw(boolean bDrawLine) {
    if (bDrawLine)
      line(pos.x, pos.y, pos.x, height);
    text(word, pos.x, pos.y + word_offset);
  }

  // true when x is on the same verical line as particle
  boolean pullingParticle(int x) {
    return (abs(pos.x - x) < diameter);
  }
  
  void perturb() {
    pos.y += random(-20, 20);
  }
  
  // helper functions
  float getSpringHeight() {
    return pos.y;
  }
}