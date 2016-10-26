// 2.26.16
//
// Fill an arbitrary polygon with non-overlapping rectangles
// (Refactoring of rectangles_inside_polygon2)


Polygon poly;
ArrayList<Rectangle> rectangles;

float min_ratio = 2.5;
float max_ratio = 9;
float min_height = 4;
float min_width = min_height * min_ratio;
float max_width = 130;

float x_shift_thresh = 50;
float y_shift_thresh = 10;
float e = 0.1;

void setup() {
  size(600, 600);
  noFill();
  stroke(200);
  background(50);
  
  poly = new Polygon();
  poly.addDefaultVertices();
  poly.computeBoundingBox();
  
  rectangles = new ArrayList<Rectangle>();
}

void draw() {
  background(50);
  poly.draw(true, true);
  
  PVector p = pickPoint(poly, rectangles);
  shiftPoint(p, rectangles);
  addRectangle(p, poly, rectangles);

  for (Rectangle r : rectangles) { r.draw(); }
}


PVector pickPoint(Polygon poly, ArrayList<Rectangle> rectangles) {
  PVector p = poly.getRandomPointInBoundingBox();
  while (!poly.contains(p) || insideRectangles(p, rectangles))
    p = poly.getRandomPointInBoundingBox();
  return p;
}

boolean insideRectangles(PVector p, ArrayList<Rectangle> rectangles) {
  for (Rectangle r : rectangles) {
    if (r.contains(p)) { return true; }
  }
  return false;
}

/* 
 If p is within a certain threshold to the right or below the polygon, shift it
 left or up to be adjacent to the polygon edge if that doesn't put it inside
 an existing rectangle
*/
void shiftPoint(PVector p, ArrayList<Rectangle> rectangles) {
  Constraints cp = getConstraints(p, poly);
  
  int min_direction = cp.getMinDirection();
  IValue sl = cp.getValue(min_direction);
  if (sl.i >=0) {
    Segment s = poly.segments[sl.i];
    float dist_ps = sl.val;
    
    if (s.tiltRight() && (min_direction == 1 || min_direction == 4)) {
      if (min_direction <= 2 && abs(dist_ps) < y_shift_thresh) {
        p.y += dist_ps;  // shift up
        if (insideRectangles(p, rectangles))  // reverse the operation if it puts us inside a rectangle
          p.y -= dist_ps;
      }
      else if (abs(dist_ps) < x_shift_thresh) { 
        p.x += dist_ps; // shift left
        if (insideRectangles(p, rectangles))  // reverse the operation if it puts us inside a rectangle
        p.x -= dist_ps;
      }
    }
  }
}

/*
*/
void addRectangle(PVector tl, Polygon poly, ArrayList<Rectangle> rectangles) {
  
  // First constrain width and height of new rectangles based on existing rectangles 
  PVector dimensions = new PVector(width - tl.x, height - tl.y);
  dimensions.x = min(max_width, dimensions.x);
  dimensions.y = min(dimensions.x / min_ratio, dimensions.y);
  constrainFromExistingRectangles(tl, dimensions, rectangles);
  
  // Now look at constraints from edges of polygon
  Constraints ctl = getConstraints(tl, poly);
  if (ctl.east.i >= 0 && ctl.east.val > 0) { 
    constrainFromPolygonEast(tl, ctl, dimensions, poly);
  }
  
  // For south, check both tl and tr
  if (ctl.south.i >= 0 && ctl.south.val > 0) {
    constrainFromPolygonSouth(tl, ctl, dimensions, poly);
  }
  PVector tr = new PVector(tl.x + dimensions.x, tl.y);
  Constraints ctr = getConstraints(tr, poly);
  if (ctl.south.i >= 0 && ctr.south.val > 0) {
    constrainFromPolygonSouth(tr, ctr, dimensions, poly);
  }
  
  //Adjust based on ratio range of width & height
  if (dimensions.y > dimensions.x / min_ratio)
    dimensions.y = dimensions.x / random(min_ratio, max_ratio);
  //if (dimensions.y < min_height)
  //  return;
  if (dimensions.y < dimensions.x / max_ratio)
    dimensions.x = dimensions.y * max_ratio;
  
  // Create and add the rectangle
  if (dimensions.y >= min_height) {
    Rectangle r = new Rectangle(tl.x, tl.y, dimensions.x, dimensions.y);
    
    // Make sure all points of rectangle are inside polygon
    if (poly.contains(r.tr) && poly.contains(r.br) && poly.contains(r.bl) 
      && !verticesInsideRectangle(poly.vertices, r)) {
       rectangles.add(r);
    }
  }
}

boolean verticesInsideRectangle(PVector[] vertices, Rectangle r) {
  for (int i = 0; i < vertices.length; i++) {
    if (r.contains(vertices[i]))
      return true;
  }
  return false;
}

void constrainFromExistingRectangles(PVector tl, PVector dimensions, ArrayList<Rectangle> rectangles) {
  for (Rectangle r : rectangles) {
    if ((r.getMinY() > tl.y) && (r.getMaxX() > tl.x))
      dimensions.y = min(dimensions.y, r.getMinY() - tl.y);
    else if ((r.getMinX() > tl.x) && (r.getMaxY() > tl.y))
      dimensions.x = min(dimensions.x, r.getMinX() - tl.x);
  }
}

void constrainFromPolygonEast(PVector tl, Constraints ctl, PVector dimensions, Polygon poly) {
  Segment s = poly.segments[ctl.east.i];
  float n = random(min_ratio, max_ratio);
  
  // pick a random ratio between width & height, and generate dimensions based on that
  // where the resulting rectangle's bottom right corner hits the segment
  if (s.tiltRight()) {
    float max_width = ctl.east.val;
    float x_dist = -(n * s.getSlope() * max_width) / (1 - n * s.getSlope());
    PVector tr = new PVector(tl.x + x_dist, tl.y);
    float y_dist = Utils.crossingDistanceVertical(tr, s);
    
    dimensions.x = min(dimensions.x, abs(x_dist));
    if (y_dist > 0)
      dimensions.y = min(dimensions.y, y_dist);
  }
  else if (s.tiltLeft()) {
    float x_dist = ctl.east.val;
    float y_dist = x_dist / n;
    
    PVector bl = new PVector(tl.x, tl.y + y_dist);
    Constraints cbl = getConstraints(bl, poly);
    PVector tr = new PVector(tl.x + x_dist, tl.y);
    Constraints ctr = getConstraints(tr, poly);
    
    if (cbl.east.val > 0)
      dimensions.x = min(dimensions.x, min(x_dist, cbl.east.val));
    if (ctr.south.val > 0)
      dimensions.y = min(dimensions.y, min(y_dist, ctr.south.val));
  }
}

void constrainFromPolygonSouth(PVector p, Constraints cp, PVector dimensions, Polygon poly) {
    Segment s = poly.segments[cp.south.i];
    dimensions.y = min(dimensions.y, cp.south.val);
    Rectangle r = new Rectangle(p.x, p.y, dimensions.x, dimensions.y);
    if (r.contains(s.a)) {
      dimensions.y = s.a.y - p.y;
    } else if (r.contains(s.b)) {
      dimensions.y = s.b.y - p.y;
    }
}

/*
  From Point p, shoot a ray in each of the four cardinal directions
  Find the segment id of the closest intersection in each direction
  and the distance from p to these segments
*/
Constraints getConstraints(PVector p, Polygon poly) {
  // initialize empty object to hold constraint info
  Constraints constraints = new Constraints();
  
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
    addRectangle(new PVector(mouseX, mouseY), poly, rectangles);
  }
}

void keyPressed() {
  if (key == 'e') {
    println("clear");
    rectangles.clear();
  }
  else if (keyCode == 32) {
    println("space");
  }
}