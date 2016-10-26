// Specifies a simple polygon (can be concave or convex, no holes)

class Polygon {
  ArrayList<PVector> vertices;
  int num_vertices;
  int num_segments;
  float min_x, min_y, max_x, max_y;
  
  PVector[] vertices_array;
  Segment[] segments;
  
  Polygon() {
    vertices = new ArrayList<PVector>();
    num_vertices = 0;
    min_x = 0; min_y = 0; max_x = 0; max_y = 0;
  }
  
  void computeBoundingBox() {
    computeVerticesArray();
    computeSegmentsArray();
    
    min_x = width; min_y = height; max_x = 0; max_y = 0;
    for (int i = 0; i < num_vertices; i++) {
      min_x = min(vertices_array[i].x, min_x);
      min_y = min(vertices_array[i].y, min_y);
      max_x = max(vertices_array[i].x, max_x);
      max_y = max(vertices_array[i].y, max_y);
    }
  }
  
  void computeVerticesArray() {
    vertices_array = new PVector[num_vertices];
    for (int i = 0; i < num_vertices; i++) {
      vertices_array[i] = vertices.get(i);
    }
  }
  
  void computeSegmentsArray() {
    num_segments = num_vertices - 1;
    segments = new Segment[num_segments];
    for(int i = 0; i < num_segments; i ++) {
      segments[i] = new Segment(vertices_array[i], vertices_array[i+1]);
    }
    segments[num_segments - 1] = 
        new Segment(vertices_array[num_vertices - 1], vertices_array[0]);
  }
  
  void addVertex(PVector p) {
    vertices.add(p);
    num_vertices++;
  }
  
  PVector getVertex(int index) {
    return vertices_array[index];
  }
  
  Segment getSegment(int index) {
    return segments[index];
  }
  
  PVector[] getVertices() {
    if (vertices_array != null)
      return vertices_array;
    computeVerticesArray();
    return vertices_array;
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
      if ( ((vertices.get(i).y > y) != (vertices.get(j).y > y)) &&
          (x < (vertices.get(j).x - vertices.get(i).x) * 
                  (y - vertices.get(i).y) / (vertices.get(j).y - vertices.get(i).y) + vertices.get(i).x)) {
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
  
  void draw() {
    for (int i = 0; i < num_vertices - 1; i++) {
      PVector p_a = vertices.get(i);
      PVector p_b = vertices.get(i+1);
      line(p_a.x, p_a.y, p_b.x, p_b.y);
    }
    PVector p_0 = vertices.get(0);
    PVector p_n = vertices.get(num_vertices - 1);
    line(p_0.x, p_0.y, p_n.x, p_n.y);
  }
  
  void drawSegment(int a, int b) {
    PVector p_a = vertices.get(a);
    PVector p_b = vertices.get(b);
    line(p_a.x, p_a.y, p_b.x, p_b.y);
  }
  
  // for debugging, keep a default polygon around
  void addDefaultVertices() {
     addVertex(new PVector(61, 93));
     addVertex(new PVector(156, 192));
     addVertex(new PVector(342, 189));
     addVertex(new PVector(386, 47));
     addVertex(new PVector(548, 247));
     addVertex(new PVector(556, 455));
     addVertex(new PVector(269, 550));
     addVertex(new PVector(26, 458));
     addVertex(new PVector(86, 232));
  }
  
  void printInfo() {
    println("No. Vertices: " + num_vertices);
    for (int i = 0; i < num_vertices; i++) {
      PVector v = vertices_array[i];
      println(i + ": " + v.x + ", " + v.y);
    }
    println("Bounding Box: " + min_x + ", " + min_y + "---" + max_x + ", " + max_y);
  }
}