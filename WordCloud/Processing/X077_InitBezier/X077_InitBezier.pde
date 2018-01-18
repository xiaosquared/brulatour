// 1.8.18
//
// Init Bezier
//
// Getting acquainted with Bezier curves
//
// - Animates the drawing of the curve by steps
// - Press any key to resetart

ArrayList<PVector> ac_points;
PVector a1 = new PVector(120, 430);
PVector c1 = new PVector(250, 190);
PVector c2 = new PVector(530, 200);
PVector a2 = new PVector(630, 450);
float radius = 20;

PVector current_point;

int steps = 100;
ArrayList<PVector> step_points;

int index = 0;

void setup() {
  size(800, 600);
  background(30);
  stroke(250);
  noFill();
  
  ac_points = new ArrayList<PVector>();
  ac_points.add(a1);
  ac_points.add(c1);
  ac_points.add(c2);
  ac_points.add(a2);
  
  step_points = new ArrayList<PVector>();
  initStepPoints();
}

void draw() {
  background(30);
  drawPoints(ac_points, 15);
  drawBezierSegment(index);
  delay(50);
  if (index < steps) {
    index++;
  }
}

//////////////////

void initStepPoints() {
  for (int i = 0; i < steps; i++) {
    float t = i / float(steps);
    float x = bezierPoint(a1.x, c1.x, c2.x, a2.x, t);
    float y = bezierPoint(a1.y, c1.y, c2.y, a2.y, t);
    step_points.add(new PVector(x, y));
  }
}

void drawBezierSegment(int index) {
  PVector prev = step_points.get(0);
  for (int i = 1; i < index; i++) {
    PVector current = step_points.get(i);
    line(prev.x, prev.y, current.x, current.y);
    prev = current;
  }
}

void drawPoints(ArrayList<PVector> pts, float r) {
  for (PVector p : pts) {
    ellipse(p.x, p.y, r, r);
  }
}

void drawBezier() {
  bezier(a1.x, a1.y, c1.x, c1.y, c2.x, c2.y, a2.x, a2.y);
}

PVector getPoint(float x, float y) {
  for (PVector p : ac_points) {
    if (dist(x, y, p.x, p.y) < radius)
      return p;
  }
  return null;
}

void keyPressed() {
  index = 0;
}

void mousePressed() {
  PVector p = getPoint(mouseX, mouseY);
  if (p != null) {
    current_point = p;
  }
}

void mouseDragged() {
  current_point.x = mouseX;
  current_point.y = mouseY;
}

void mouseReleased() {
  step_points.clear();
  initStepPoints();
}