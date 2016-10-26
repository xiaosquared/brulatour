class Block {
  PVector pos;
  PVector vel;
  PVector acc;
  PVector g = new PVector(0, 0.5);
  float w;
  float h;
  
  boolean inWater = false;
  
  Block(float x, float y, float w, float h) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = g.copy();
    this.w = w;
    this.h = h;
  }
  
  void update() {
    if (inWater) {
      // Buoyancy force
      float submerged = (pos.y - water_level + h/2) * w;
      float buoy = - submerged * water_density * g.y;
      
      // Drag
      float drag = 0.06 * vel.y * vel.y;
      if (vel.y > 0)
        drag = - drag;
      
      // total force
      acc.y = g.y + drag + buoy;
    }
    
    vel.add(acc);
    pos.add(vel);
  }
  
  void draw() {
    rectMode(CENTER);
    noStroke();
    fill(100);
    rect(pos.x, pos.y, w, h);
  }
}