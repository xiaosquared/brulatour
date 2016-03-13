class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  String word;
  
  Particle (PVector l, String w) {
    word = w;
    location = l;
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(0, 0);
    lifespan = 255;
  }
  
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1;
  }
 
  void draw() {
    noStroke();
    fill(200, lifespan);
    
    pushMatrix();
    translate(location.x, location.y);
    rotate(-HALF_PI);
    text(word, 0, 0);
    popMatrix();
  }
  
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    }
    return false;
  }
  
  void run() {
    update();
    draw();
  }
}