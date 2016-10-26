// 10.6.16
//
// Flocking Test
//
// Original code by Daniel Shiffman
// Modified where birds have become words


Flock flock;
PFont font;

void setup() {
  size(1200, 600);
  
  font = createFont("American Typewriter", 12);
  textFont(font, 12);
  
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 50; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
}

void draw() {
  background(50);
  flock.run();
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}