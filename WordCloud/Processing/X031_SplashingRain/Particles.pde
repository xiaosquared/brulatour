class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  
  Particle(PVector pos) {
    this.pos = pos;
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
  }
  
  Particle (PVector pos, PVector vel) {
    this.pos = pos;
    this.vel = vel;
    this.acc = new PVector(0, 0);
  }
  
  Particle (PVector pos, PVector vel, PVector acc) {
    this.pos = pos;
    this.vel = vel;
    this.acc = acc;
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
    fill(255);
    noStroke();
    ellipse(pos.x, pos.y, 5, 5);
  }
  
  boolean isDead() {
    return pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height;
  }
  
  void respawn() {}
}

class Spring extends Particle {
  float k = 0.025;
  float target_height;
  float damping = 0.04;
  
  Spring(PVector pos) {
    super(pos);
    target_height = pos.y;
  }
  
  void update() {
    float dist_y = pos.y - target_height;
    acc.y = (-k * dist_y) - (damping * vel.y);
    super.update();
  }
  
  void perturb() {
    Ani.to(this.pos, 0.1, "y", random(target_height - 50, target_height + 50));
  }
  
  float getSpringHeight() {
    return pos.y;
  }
}

class SplashDrop extends Particle {
  float lifespan = 20;
  
  SplashDrop(PVector p, PVector v, PVector a) {
    super(p, v, a);
  }
  
  void update() {
    lifespan --;
    super.update();
  }
  
  void draw() {
    noStroke();
    fill(200, min(255, lifespan*30));
    ellipse(pos.x, pos.y, 2, 2);
    
  }
  
  boolean isDead() {
    return lifespan < 0;
  }
}

class RainDrop extends Particle {
  RainDrop(PVector p, PVector v, PVector a) {
    super(p, v, a);
  }
  
  void respawn() {
    pos.x = random(4, width-4);
    pos.y = -random(50);
    vel.y = 15;
  }
  
  void draw() {
    fill(200);
    stroke(200);
    ellipse(pos.x, pos.y, 2, 2);
  }
}