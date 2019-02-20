// 9.21.16
//
// Spring Test
//
// Modeling a single verticle spring with damping 
// (a bunch of springs models a 2d water surface)
// Press mouse anywhere to perturb it a little
// Drag to move the particle vertically

Particle p = new Particle(new PVector(300, 300));
boolean doUpdate = true;

void setup() {
  size(600, 600, P2D);
  background(50);
  stroke(200);
  fill(100);
}

void draw() {
  background(50);
  p.draw();
  if (doUpdate)
    p.update();
}

void mouseDragged() {
  if (p.insideParticle(mouseX, mouseY)) {
    doUpdate = false;
    p.pos.y = mouseY;
  }
}

void mouseReleased() {
  doUpdate = true;
}
