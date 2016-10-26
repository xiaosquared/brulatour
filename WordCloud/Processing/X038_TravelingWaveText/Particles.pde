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
  //float k = 0.025;
  float k = 0.0025;
  float target_height;
  float damping = 0.03;
  
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
  
  float getHeightDiff() {
    return pos.y - target_height;
  }
}

class SplashDrop extends Particle {
  float lifespan = 20;
  char letter;
  int font_size = 8;
  
  SplashDrop(PVector p, PVector v, PVector a, char l) {
    super(p, v, a);
    letter = l;
  }
  
  void update() {
    lifespan --;
    super.update();
  }
  
  void draw(boolean letters) {
    if (letters) {
      float theta = map(pos.x,0,width,0,TWO_PI*2);
      fill(200, min(255, lifespan*30));
      textSize(font_size);
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(theta);
      text(letter, 0, 0);
      popMatrix(); 
    } else {
      noStroke();
      fill(200, min(255, lifespan*30));
      ellipse(pos.x, pos.y, 2, 2);
    }
  }
  
  boolean isDead() {
    return lifespan < 0;
  }
}

class RainDrop extends Particle {
  String word;
  int font_size = 8;
  float word_width;
  int shade = (int)random(70, 170);
  
  RainDrop(PVector p, PVector v, PVector a, String w) {
    super(p, v, a);
    word = w;
    textSize(font_size);
    word_width = textWidth(w);
  }
 
  void respawn(boolean stop) {
    pos.x = random(4, width-4);
    pos.y = -random(50);
    vel.y = stop ? 0 : 10;
    acc.y = stop ? 0 : 0.1;
  }
  
  void draw(boolean letters) {
    if (letters) {
      fill(shade);
      textSize(font_size);
      noStroke();
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(-HALF_PI);
      text(word, 0, 0);
      popMatrix();
    } else {
      fill(200);
      stroke(200);
      ellipse(pos.x, pos.y, 2, 2);
    }
  }
}