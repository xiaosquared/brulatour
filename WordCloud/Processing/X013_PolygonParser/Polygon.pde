// Specifies a simple polygon (can be concave or convex, no holes)

class Polygon {
  ArrayList<PVector> vertices_temp;
  int num_vertices;
  float min_x, min_y, max_x, max_y;
  
  PVector[] vertices;
  Segment[] segments;
  
  float vertex_radius = 10;
  int selected_vertex = -1;

  boolean inProgress = false;
  
  color c = color(200);

  Polygon(boolean inProgress) {
    this();
    this.inProgress = inProgress;
  }

  Polygon() {
    vertices_temp = new ArrayList<PVector>();
    num_vertices = 0;
    min_x = 0; min_y = 0; max_x = 0; max_y = 0;
  }
  
  void complete() {
    computeVerticesArray();
    computeSegmentsArray();
    computeBoundingBox();
    this.inProgress = false;
  }
  
  void computeBoundingBox() {
    min_x = width; min_y = height; max_x = 0; max_y = 0;
    for (int i = 0; i < num_vertices; i++) {
      min_x = min(vertices[i].x, min_x);
      min_y = min(vertices[i].y, min_y);
      max_x = max(vertices[i].x, max_x);
      max_y = max(vertices[i].y, max_y);
    }
  }
  
  void computeVerticesArray() {
    vertices = new PVector[num_vertices];
    for (int i = 0; i < num_vertices; i++) {
      vertices[i] = vertices_temp.get(i);
    }
  }
  
  void computeSegmentsArray() {
    segments = new Segment[num_vertices];
    for(int i = 0; i < num_vertices-1; i ++) {
      segments[i] = new Segment(vertices[i], vertices[i+1]);
    }
    segments[num_vertices - 1] = 
        new Segment(vertices[num_vertices - 1], vertices[0]);
  }
  
  void addVertex(PVector p) {
    vertices_temp.add(p);
    num_vertices++;
  }
  
  PVector getVertex(int index) {
    return vertices[index];
  }
  
  Segment getSegment(int index) {
    return segments[index];
  }
  
  PVector[] getVertices() {
    if (vertices != null)
      return vertices;
    computeVerticesArray();
    return vertices;
  }
  
  // whether point x, y is inside polygon
  boolean contains(float x, float y) {
    // first quick test of bounding box
    if (x < min_x || y < min_y || x > max_x || y > max_y)
      return false;
      
    // then ray casting test
    int i, j;
    boolean c = false;
    for (i = 0, j = num_vertices - 1; i < num_vertices; j = i++) {
      if ( ((vertices[i].y > y) != (vertices[j].y > y)) &&
          (x < (vertices[j].x - vertices[i].x) * 
                  (y - vertices[i].y) / (vertices[j].y - vertices[i].y) + vertices[i].x)) {
          c = !c; }
    }
    return c;
  }
  
  boolean contains(PVector p) {
    return contains(p.x, p.y);
  }
  
  PVector getRandomPointInBoundingBox() {
    return new PVector(random(min_x, max_x), random(min_y, max_y));
  }
  
  void setColor(color c) { this.c = c; }
  
  void draw() { draw(true, false); }
  
  void draw(boolean drawVertices) {
    if (drawVertices)
      draw(false, true);
  }

  void draw(boolean drawSegments, boolean drawVertices) {
    if (inProgress) {
      drawVerticesTemp();
      return;
    }
    
    stroke(c);
    for (int i = 0; i < num_vertices; i++) {
      if (drawSegments)
        drawSegment(i);
      if (drawVertices)
        drawVertex(i);
    }
  }

  void drawSegment(int i) {
    Segment s = segments[i];
    line(s.a.x, s.a.y, s.b.x, s.b.y);
  }
  
  void drawSegment(int a, int b) {
    PVector p_a = vertices[a];
    PVector p_b = vertices[b];
    line(p_a.x, p_a.y, p_b.x, p_b.y);
  }

  void drawVertex(int i) {
    PVector p = vertices[i];
    ellipse(p.x, p.y, vertex_radius, vertex_radius);
  }
  
  void drawVerticesTemp() {
    for (PVector p : vertices_temp) {
      ellipse(p.x, p.y, vertex_radius, vertex_radius);
    }
  }
  
  int selectVertex(int x, int y) {
    for (int i = 0; i < num_vertices; i++) {
      if (dist(x, y, vertices[i].x, vertices[i].y) < vertex_radius) {
        selected_vertex = i; 
        return i;
      }
    }
    selected_vertex = -1;
    return -1;
  }
  
  void setSelectedVertex(int x, int y) {
    if (selected_vertex > -1) {
      vertices[selected_vertex].x = x;
      vertices[selected_vertex].y = y;
    }
  }
  
  int unselectVertex() {
    computeBoundingBox();
    int old_vertex = selected_vertex; 
    selected_vertex = -1;
    return old_vertex;
  }
  
  void printInfo() {
    println("No. Vertices: " + num_vertices);
    for (int i = 0; i < num_vertices; i++) {
      PVector v = vertices[i];
      println(i + ": " + v.x + ", " + v.y);
    }
    println("Bounding Box: " + min_x + ", " + min_y + "---" + max_x + ", " + max_y);
  }
}