// 2.19.16
//
// Given a point p inside a polygon, draws a rectangle with p as top left
// that does not extend beyond the polygon

Polygon poly;
int count = 0;
int max_count = 1000;

void setup() {
  size(600, 600);
  noFill();
  stroke(200);
  background(50);

  poly = new Polygon();
  poly.addDefaultVertices();
  poly.computeBoundingBox();
  poly.printInfo();
}

void draw() {
  poly.draw();
  if (count < max_count) {
    PVector p = pickPoint(poly);
    PVector dim_rect = constraintsFromPolygon(p, poly);
    rect(p.x, p.y, dim_rect.x, dim_rect.y);
    count++;
  }
}



void mousePressed() {
  // println(mouseX + ", " + mouseY);
  PVector p = new PVector(mouseX, mouseY);
  PVector dim_rect = constraintsFromPolygon(p, poly);
  rect(p.x, p.y, dim_rect.x, dim_rect.y);
}

PVector pickPoint(Polygon poly) {
  PVector p = poly.getRandomPointInBoundingBox();
  while (!poly.contains(p))
  p = poly.getRandomPointInBoundingBox();
  return p;
}

PVector constraintsFromPolygon(PVector p, Polygon poly) {
  // Figure out which segments cross p vertically and horizontally
  int crossing_index_h = -1;
  float crossing_dist_h = -1;
  float crossing_dist_v = -1;
  for (int i = 0; i < poly.segments.length; i++) {
    Segment s = poly.segments[i];
    float current_crossing_h = Utils.crossingDistanceHorizontal(p, s);
    float current_crossing_v = Utils.crossingDistanceVertical(p, s);

    if (current_crossing_h > 0) {
      if (crossing_dist_h <= 0) {
        crossing_dist_h = current_crossing_h;
        crossing_index_h = i;
      } else if (current_crossing_h < crossing_dist_h) {
        crossing_dist_h = current_crossing_h;
        crossing_index_h = i;
      }
    }

    if (current_crossing_v > 0) {
      if (crossing_dist_v <= 0) {
        crossing_dist_v = current_crossing_v;
      } else if (current_crossing_v < crossing_dist_v) {
        crossing_dist_v = current_crossing_v;
      }
    }
  }

  // Figure out dimensions of rectangle
  PVector dim_rect = new PVector(500 - p.x, 500 - p.y); 
  if (crossing_index_h > -1) {
    Segment s = poly.segments[crossing_index_h];

    if (s.tiltRight()) {
      dim_rect = constraintsFromSegmentSlopedRight(p, s, random(3, 7));
      if (crossing_dist_v > 0)
        dim_rect.y = min(dim_rect.y, crossing_dist_v);
    } else if (s.tiltLeft()) {
      dim_rect.x = crossing_dist_h;

      // find vertical crossing from top right
      PVector tr = new PVector(p.x + dim_rect.x, p.y);
      float crossing_dist_v_tr = -1;

      for (int i = 0; i < poly.segments.length; i++) {
        s = poly.segments[i];
        float current_crossing_v = Utils.crossingDistanceVertical(tr, s);

        if (current_crossing_v > 0.001) {
          if (crossing_dist_v_tr < 0) crossing_dist_v_tr = current_crossing_v;
          else crossing_dist_v_tr = min(current_crossing_v, crossing_dist_v_tr);
        }
      }
      if (crossing_dist_v_tr > 0) {
        dim_rect.y = min(crossing_dist_v, crossing_dist_v_tr);
      }
    }
  }
  return dim_rect;
}

/**
 * @return width & height for rectangle starting from p with ratio n
 * based on constraints from segment s
 */
PVector constraintsFromSegmentSlopedRight(PVector p, Segment s, float n) {
  // Find horizontal constraint from p (top left point of rect)
  float max_width = Utils.crossingDistanceHorizontal(p, s); 

  // x_dist = ratio * y_dist
  float x_dist = -(n * s.slope * max_width)/ (1 - n * s.slope);

  PVector tr = new PVector(p.x + x_dist, p.y);
  float y_dist = Utils.crossingDistanceVertical(tr, s);

  return new PVector(x_dist, y_dist);
}