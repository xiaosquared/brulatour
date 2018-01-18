// 1.10.18
//
// Bezier Maker
//
// To make a curve
//   - 'b' to start and to add new segments
//   - 'q' to exit middle of a new segment
//   - drag any control or anchor point to modify 
//   - green is control point, red is anchor point
//   - 'c' toggles visibility of control points
//   - 'l' displays length of entire curve
//   - delete while holding down a point deletes all following segments 

BezierCurve b;
float r = 5;
float select_radius = 30;
BPoint current_point;
BPoint ct1;
BPoint ct2;

public enum DrawState { ANCHOR, CTRL1, CTRL2, ANCHOR2, NONE }
DrawState state = DrawState.NONE;

void setup() {
  size(800, 600);
  background(30);
  stroke(250);
}

void draw() {
  background(30);
  if (b != null)
    b.draw();
  
  drawCursor();
  
  if (state != DrawState.NONE)
    drawPoints();
}

void drawCursor() {
  if (state == DrawState.ANCHOR || state == DrawState.ANCHOR2) {
    fill(255, 0, 0);
    ellipse(mouseX, mouseY, r, r);
  }
  else if (state == DrawState.CTRL1 || state == DrawState.CTRL2) {
    fill(0, 255, 0);
    ellipse(mouseX, mouseY, r, r);
  }
}

void drawPoints() {
  if (ct1 != null)
    ct1.draw();
  if (ct2 != null)
    ct2.draw();
}

void keyPressed() {
  if (keyCode == 8 && state == DrawState.NONE) {
    if (current_point.isSelected()) 
      b.deleteAllFollowing(current_point);
  }
  
  else if (key == 'q') {
    state = DrawState.NONE;
    ct1 = null; ct2 = null;
  }
  
  else if (key == 'b' && state == DrawState.NONE) {
    if (b == null || b.isEmpty())
      state = DrawState.ANCHOR;
    else
      state = DrawState.CTRL1;
  }
  else if (key == 'l' && state == DrawState.NONE) {
    if (b != null)
      println(b.getLength());
  }
  else if (key == 'c') {
    b.toggleDrawCurveOnly();
  }
}

void mousePressed() {
  switch(state) {
    case NONE:
    if (b != null) {
      BPoint p = b.getSelectedPoint(mouseX, mouseY, select_radius);
      if (p != null) {
        current_point = p;
        current_point.setSelected(true);
      }
    }
    break;
    
    case ANCHOR:
      if (b == null || b.isEmpty()) {
        b = new BezierCurve(mouseX, mouseY);
      }
      state = DrawState.CTRL1;
    break;
    
    case CTRL1:
      ct1 = new BPoint(mouseX, mouseY, false);
      state = DrawState.CTRL2;
    break;
    
    case CTRL2:
      ct2 = new BPoint(mouseX, mouseY, false);
      state = DrawState.ANCHOR2;
    break;
    
    case ANCHOR2:
      b.addSegment(ct1, ct2, new BPoint(mouseX, mouseY, true));
      ct1 = null;
      ct2 = null;
      state = DrawState.NONE;
    break;
  }
}

void mouseDragged() {
  if (state == DrawState.NONE) {
    current_point.setX(mouseX);
    current_point.setY(mouseY);
  }
}

void mouseReleased() {
  if (state == DrawState.NONE) {
    if (current_point != null)
      current_point.setSelected(false);
  }
}