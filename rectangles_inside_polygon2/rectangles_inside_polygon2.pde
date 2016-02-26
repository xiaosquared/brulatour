// 2.19.16
//
// Given a point p inside a polygon, draws a rectangle with p as top left
// that does not extend beyond the polygon
//
// TODO: Fix the case when it sticks out of the bottom

Polygon poly;
ArrayList<Rectangle> rects;

float min_ratio = 2;  
float max_ratio = 8;
float max_width = 100;
float min_height = 4;

float x_shift_thresh = 50;
float y_shift_thresh = 20;

int count = 0;
int max_count = 1000;
float e = 0.1;

void setup() {
  size(600, 600);
  noFill();
  stroke(200);
  background(50);

  poly = new Polygon();
  poly.addDefaultVertices();
  poly.computeBoundingBox();
  //poly.printInfo();
  poly.draw(true, true);
  
  rects = new ArrayList<Rectangle>();
}

void draw() {
  background(50);
  poly.draw(true, true);
  
  PVector p = pickPoint(poly);
  addRectangle(p);
  
  for (Rectangle r : rects) {  r.draw(); }
}

/*
  // Code for adding a Rectangle
  
  1. Pick a random point P inside the polygon
  2. From that point, look at the 4 cardinal directions (north, south, east, west)
      and find the segment of closest intersection in each direction
  3. Find which one we are the closest to. That's the segment that we will anchor from.
      Shift the P to anchor from the segment.
  4. Depending on the tilt of the segment and which side of it we are on, there are 4 cases.
      Find the constraints for each case.
*/

PVector pickPoint(Polygon poly) {
  PVector p = poly.getRandomPointInBoundingBox();
  while (!poly.contains(p) || insideRectangles(p))
    p = poly.getRandomPointInBoundingBox();
  return p;
}

boolean insideRectangles(PVector p) {
  for (Rectangle r : rects) {
    if (r.contains(p))
      return true;
  }
  return false;
}


void addRectangle(PVector p) {
  CardinalConstraints constraints = getCardinalConstraints(p, poly);
  constraints.printInfo();
  
  int dir = constraints.getMinDirection();
  println(dir);
  IValue sl = constraints.getValue(dir);
  if (sl.i >= 0) {
    Segment s = poly.segments[sl.i];
    s.printInfo();
    float dist = sl.val;

    if (s.tiltRight()) {
      if (dir == 1 || dir == 4) {
        println("CASE TL");
        
        if ((dir <= 2) && (abs(dist) < y_shift_thresh)) p.y += dist;
        else if (abs(dist) < x_shift_thresh) p.x += dist;
        
        if (insideRectangles(p))
          return;
      }
    } 
      addRectangleTL(p);
  }
}

void addRectangleTL(PVector tl) {
  
  // Constrain width and height based on existing rectangles
  float r_width = min(max_width, width - tl.x);
  float r_height = min(r_width / min_ratio, height - tl.y);
  for (Rectangle r : rects) {
    if ((r.getMinY() > tl.y) && (r.getMaxX() > tl.x)) 
      r_height = min(r_height, r.getMinY() - tl.y);
    else if ((r.getMinX() > tl.x) && (r.getMaxY() > tl.y)) 
      r_width = min(r_width, r.getMinX() - tl.x);
  }
  
  float n = random(min_ratio, max_ratio); // ratio
  
  // Constrain based on right edges of polygon
  CardinalConstraints ctl = getCardinalConstraints(tl, poly);
  if (ctl.east.i >= 0 && ctl.east.val > 0) {
    Segment sEast = poly.segments[ctl.east.i];
    if (sEast.tiltRight()) {    
      
      float max_width = ctl.east.val;
      float x_dist = -(n * sEast.getSlope() * max_width)/ (1 - n * sEast.getSlope());
      PVector tr = new PVector(tl.x + x_dist, tl.y);
      float y_dist = Utils.crossingDistanceVertical(tr, sEast);
      
      r_width = min(r_width, abs(x_dist));
      r_height = min(r_height, abs(y_dist));
    }
    
    else if (sEast.tiltLeft()) {
      float x_dist = ctl.east.val;
      float y_dist = x_dist / n;
      
      PVector bl = new PVector(tl.x, tl.y + y_dist);
      CardinalConstraints cbl = getCardinalConstraints(bl, poly);
      PVector tr = new PVector(tl.x + x_dist, tl.y);
      CardinalConstraints ctr = getCardinalConstraints(tr, poly);
      
      if (cbl.east.val > 0) {
        r_width = min(r_width, min(x_dist, cbl.east.val));
      }
      if (ctr.south.val > 0) {
        r_height = min(r_height, min(y_dist, ctr.south.val));
      }
    } 
  }
  
  // Constraints based on bottom edges of polygon
  if (ctl.south.i >= 0 && ctl.south.val > 0) {
    r_height = min(r_height, ctl.south.val);
    Segment s = poly.segments[ctl.south.i];
    Rectangle r = new Rectangle(tl.x, tl.y, r_width, r_height);
    if (r.contains(s.a)) {
      r_height = s.a.y - tl.y;
    }
  }
  PVector tr = new PVector(tl.x + r_width, tl.y);
    CardinalConstraints ctr = getCardinalConstraints(tr, poly);
  if (ctr.south.i >= 0 && ctr.south.val > 0) {
     r_height = min(r_height, ctr.south.val);
     Segment s = poly.segments[ctl.south.i];
     Rectangle r = new Rectangle(tl.x, tl.y, r_width, r_height);
     if (r.contains(s.b)) {
      r_height = s.b.y - tl.y;
    }  
  }
  
  // Adjust based on ratio range of width & height
  if (r_height > r_width/min_ratio)
    r_height = r_width/random(min_ratio, max_ratio);
  if (r_height < min_height)
    return;
  if (r_height < r_width/max_ratio)
    r_width = r_height * max_ratio;
  
  // TODO: final check that rectangle doesn't contain any of the points of the polygon
  
  Rectangle r = new Rectangle(tl.x, tl.y, r_width, r_height);
  rects.add(r);
  
}

CardinalConstraints getCardinalConstraints(PVector p, Polygon poly) {
  CardinalConstraints constraints = new CardinalConstraints();
  
  for (int i = 0; i < poly.segments.length; i++) {
    Segment s = poly.segments[i];
    float crossing_h = Utils.crossingDistanceHorizontal(p, s);
    float crossing_v = Utils.crossingDistanceVertical(p, s);

    if ((crossing_h > e) &&
        (constraints.east.val == 0 || crossing_h < constraints.east.val)) {
        constraints.east.i = i;
        constraints.east.val = crossing_h;
    } else if ((crossing_h < -e) &&
        (constraints.west.val == 0 || crossing_h > constraints.west.val)) {
        constraints.west.i = i;
        constraints.west.val = crossing_h;
    } if ((crossing_v > e) &&
        (constraints.south.val == 0 || crossing_v < constraints.south.val)) {
        constraints.south.i = i;
        constraints.south.val = crossing_v;
    } else if ((crossing_v < -e) &&
        (constraints.north.val == 0 || crossing_v > constraints.north.val)) {
        constraints.north.i = i;
        constraints.north.val = crossing_v;
    }
  }
  return constraints;
}

/**
 * @return width & height for rectangle starting from p with ratio n
 * based on constraints from segment s
 */
PVector constraintsFromSegmentSlopedRight(PVector p, Segment s, float n) {
  // Find horizontal constraint from p (top left point of rect)
  float max_width = Utils.crossingDistanceHorizontal(p, s); 

  // x_dist = ratio * y_dist
  float x_dist = -(n * s.getSlope() * max_width)/ (1 - n * s.getSlope());

  PVector tr = new PVector(p.x + x_dist, p.y);
  float y_dist = Utils.crossingDistanceVertical(tr, s);

  return new PVector(x_dist, y_dist);
}

//////////////////
// Interactions //
//////////////////
void mousePressed() {
  poly.selectVertex(mouseX, mouseY);
}

void mouseDragged() {
  poly.setSelectedVertex(mouseX, mouseY);
}

void mouseReleased() {
  int old_vertex = poly.unselectVertex();
  
  if (old_vertex == -1) {
    addRectangle(new PVector(mouseX, mouseY));
  }
}

void keyPressed() {
  if (key == 'e') {
    println("clear");
    rects.clear();
  }
  else if (keyCode == 32) {
    println("space");
  }
}