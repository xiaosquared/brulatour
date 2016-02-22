// 2.13.16
//
// Randomized greedy filling of an arbitrary polygon with circles 
//  
// Uses a fast, elegant elgorithm to test whether 
// a point is inside a polygon As explained here:
//
// http://stackoverflow.com/questions/217578/how-can-i-determine-whether-a-2d-point-is-within-a-polygon
// https://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html

PVector[] vertices;
int numVertices = 8;
float minX, minY, maxX, maxY;

ArrayList<Circle> circles;
float minRadius = 5;
float maxRadius = 50;

int counter = 0;
int max_count = 2000;

void setup() {
  size(400, 400);
  
  // make an arbitrary convex polygon
  vertices = new PVector[numVertices];
  vertices[0] = new PVector(61, 93);
  vertices[1] = new PVector(156, 192);
  vertices[2] = new PVector(258, 139);
  vertices[3] = new PVector(286, 47);
  vertices[4] = new PVector(356, 185);
  vertices[5] = new PVector(269, 310);
  vertices[6] = new PVector(26, 298);
  vertices[7] = new PVector(86, 232);
  
  // find the bounding box
  minX = 0; minY = 0; maxX = width; maxY = height;
  for (int i = 0; i < numVertices; i++) {
     minX = min(vertices[i].x, minX);
     minY = min(vertices[i].y, minY);
     maxX = max(vertices[i].x, maxX);
     maxY = max(vertices[i].y, maxY);
  }
  
  circles = new ArrayList<Circle>();
  
  noFill();
  stroke(200);
  ellipseMode(RADIUS);
  background(50);
  drawPolygon();
}

void draw() {
  addCircle();
}

void addCircle() {
  // pick a point inside the polygon not in circles
  PVector p = pickCenterPoint(vertices, circles);

  // find min distance to all sides of polygon
  float d_vertices = minimumDistance(vertices[7], vertices[0], p);
  for (int i = 0; i < numVertices - 1; i++) {
    float d = minimumDistance(vertices[i], vertices[i+1], p);
    d_vertices = min(d, d_vertices);
  }

  // find min distance to all existing circles
  float d_circles = maxRadius;
  for (Circle c : circles) {
    float d = dist(c.x, c.y, p.x, p.y) - c.r;
    d_circles = min(d, d_circles);
  }
  
  // place circle at point with radius = min of the 2 distances
  float r = min(d_vertices, d_circles);
  if (r > 0) {
    Circle c = new Circle(p.x, p.y, r);
    circles.add(c);
    c.draw();
  }
}

/** 
* @returns PVector p inside polygon not in existing circles
*/
PVector pickCenterPoint(PVector[] vertices, ArrayList<Circle> circles) {
 // start with random point in bounding box
 PVector p = new PVector(random(minX, maxX), random(minY, maxY));
  
 while (!insidePolygon(vertices, p.x, p.y) || insideCircles(circles, p)) {
   p = new PVector(random(minX, maxX), random(minY, maxY));
 }
 return p;
}

void drawPolygon() {
  for (int i = 0; i < numVertices - 1; i++) {
    PVector p_a = vertices[i];
    PVector p_b = vertices[i+1];
    line(p_a.x, p_a.y, p_b.x, p_b.y);
  }
  PVector p_0 = vertices[0];
  PVector p_n = vertices[numVertices - 1];
  line(p_0.x, p_0.y, p_n.x, p_n.y);
}

boolean insidePolygon(PVector[] vertices, float x, float y) {
  // first the quick test of bounding box
  if (x < minX || y < minY || x > maxX || y > maxY)
    return false;
    
  // then the ray casting test
  int i, j;
  boolean c = false;
  for (i = 0, j = vertices.length - 1; i < vertices.length; j = i++) {
    if ( ((vertices[i].y > y) != (vertices[j].y > y)) &&
          (x < (vertices[j].x - vertices[i].x) * 
                  (y - vertices[i].y) / (vertices[j].y - vertices[i].y) + vertices[i].x)) {
      c = !c;              
    }
  }
  return c;
}

boolean insideCircles(ArrayList<Circle> circles, PVector p) {
  for (Circle c : circles) {
    if (c.contains(p))
      return true;
  }
  return false;
}

/** 
* @return min distance between line segment vw & point p
*/
float minimumDistance(PVector v, PVector w, PVector p) {
  float l2 = sq(v.x - w.x) + sq(v.y - w.y);
  if (l2 == 0.0) // v == w 
    return dist(v.x, v.y, p.x, p.y);
  
  float t = ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2;
  if (t < 0.0) // beyond the 'v' end of the segment   
    return dist(p.x, p.y, v.x, v.y);
  else if (t > 1.0)  // beyond the 'w' end of the segment
    return dist(p.x, p.y, w.x, w.y);
  
  // distance between p & projection on segment
  return dist(p.x, p.y, v.x + t * (w.x - v.x), v.y + t * (w.y - v.y)); 
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
  println(insidePolygon(vertices, mouseX, mouseY)); 
  addCircle();
}