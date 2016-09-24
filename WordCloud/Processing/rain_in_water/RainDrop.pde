class RainDrop {
  PVector pos;
  PVector vel;
  PVector acc;
  float START_Y = -50;
  
  RainDrop(int x) {
    pos = new PVector(x, START_Y);
    vel = new PVector(0, 15);
    acc = new PVector(0, 0.5);  
  }
  
  void run() {
    update();
    draw();
  }
  
  void update() {
    vel.add(acc);
    pos.add(vel);
  }
  
  boolean isDead() {
    return pos.y > height + 10;
  }
  
  void respawn() {
    pos.x = random(2, width-2);
    pos.y = START_Y;
    vel.y = 15;
  }
  
  void draw() {
    ellipse(pos.x, pos.y, 3, 3);
  }
}