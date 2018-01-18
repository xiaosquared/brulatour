// 1.11.18
//
// Animated Bezier
//
// To make a curve
//   - 'b' to start and to add new segments
//   - 'q' to exit middle of a new segment
//   - drag any control or anchor point to modify 
//   - green is control point, red is anchor point
//   - 'l' displays length of entire curve
//   - delete while holding down a point deletes all following segments 

import controlP5.*;
ControlP5 cp5;
Toggle viewWords;

BezierCurve b;
float r = 5;
float select_radius = 30;
BPoint current_point;
BPoint ct1;
BPoint ct2;

public enum DrawState { ANCHOR, CTRL1, CTRL2, ANCHOR2, NONE }
DrawState state = DrawState.NONE;

void setup() {
  //fullScreen(); 
  size(1200, 800);
  textAlign(CENTER, CENTER);
  background(30);
  stroke(250);
  
  cp5 = new ControlP5(this);
  cp5.addToggle("view_control_pts")
     .setPosition(40, 50)
     .setSize(50, 20)
     .setValue(true)
     .setMode(ControlP5.SWITCH);
  cp5.addToggle("view_bezier")
     .setPosition(40, 100)
     .setSize(50, 20)
     .setValue(true)
     .setMode(ControlP5.SWITCH);
     
  viewWords = cp5.addToggle("view_words")
     .setPosition(40, 150)
     .setSize(50, 20)
     .setValue(true)
     .setMode(ControlP5.SWITCH);
  
  cp5.addButton("animate")
     .setPosition(40, 200)
     .setSize(50, 20);
     
  
  PFont font = createFont("American Typewriter", 20);
  textFont(font, 20);
}

void draw() {
  background(30);
  if (b != null) {
    if (b.animateVisibility) {
      boolean done = b.animateVisibility();
      if (done)
        viewWords.setValue(true);
    }
    b.draw();
  }
  
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

/////////////////////////////////////////////////////////////

void view_control_pts(boolean flag) {
  if (b != null)
    b.viewControlPts(flag);
}

void view_bezier(boolean flag) {
  if (b != null)
    b.viewCurve(flag);
}

void view_words(boolean flag) {
  if (b != null) {
    b.setLettersVisibility(flag);
  }
}

void animate(int value) {
  println(value);
  b.letters_index = 0;
  b.animateVisibility = true;
}

/////////////////////////////////////////////////////////////

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
    b.clearLetters();
  }
  else if (key == 'f') {
    if (b == null)
      return;
    if (!b.isEmpty()) {
      b.fillWithLetters("Hello World ~ ");
    }
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