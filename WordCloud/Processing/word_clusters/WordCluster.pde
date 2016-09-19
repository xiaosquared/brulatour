class WordCluster {
  ArrayList<Word> words;
  color c = color(200);
  Polygon poly;
  boolean drawPoly = true;
  
  float min_ratio = 2.5;
  float max_ratio = 9;
  float min_height = 7;
  float min_width = min_height * min_ratio;
  float max_width = 130;
  
  float x_shift_thresh = 70;
  float y_shift_thresh = 10;
  float e = 0.1;
  
  WordCluster(Polygon poly) {
    words = new ArrayList<Word>();
    this.poly = poly;
  }
  
  void setColor(color c) { this.c = c; }
  
  void draw() {
    fill(c);
    
    Iterator<Word> it = words.iterator();
    while(it.hasNext()) {
      Word w = it.next();
      //w.update();
      w.draw();
    }
    
    if (drawPoly) {
      noFill();
      poly.draw(true, true);
    }
  }

  void clearWords() {
     words.clear();
  }
 
  // ADDING WORDS /////////////
  
  void populateRandomly(int numWords) {
    while (numWords > 0) {
      int index = ws.getRandomWordIndex();
      float size = random(4, 30);
      PVector position = new PVector(random(width-100), random(height-20));
      words.add(new Word(index, size, position));
      numWords--;
    }
  }
 
  void populateInsidePolygon(int numWords) {
    int failCount = 0;
    
    while (numWords > 0) {
      PVector p = pickPoint();
      shiftPoint(p);
      boolean success = addWord(p);
      
      if (success)
        numWords--;
      else {
        failCount++;
        if (failCount > 50)
          return;
      }
    }
  }
  
  // Helper Functions for PopulateInsidePolygon 
  
  PVector pickPoint() {
    PVector p = poly.getRandomPointInBoundingBox();
    while (!poly.contains(p) || insideAWord(p))
      p = poly.getRandomPointInBoundingBox();
    return p;
  }
  
  boolean insideAWord(PVector p) {
    for (Word w : words) {
      if (w.boxContains(p)) { return true; }
    }
    return false;
  }
  
  void shiftPoint(PVector p) {
    Constraints cp = getConstraints(p);
  
    int min_direction = cp.getMinDirection();
    IValue sl = cp.getValue(min_direction);
    if (sl.i >=0) {
      Segment s = poly.segments[sl.i];
      float dist_ps = sl.val;
    
    if (s.tiltRight() && (min_direction == 1 || min_direction == 4)) {
      if (min_direction <= 2 && abs(dist_ps) < y_shift_thresh) {
        p.y += dist_ps;  // shift up
        if (insideAWord(p))  // reverse the operation if it puts us inside a rectangle
          p.y -= dist_ps;
      }
      else if (abs(dist_ps) < x_shift_thresh) { 
        p.x += dist_ps; // shift left
        if (insideAWord(p))  // reverse the operation if it puts us inside a rectangle
        p.x -= dist_ps;
       }
      }
    }
  }
  
  boolean addWord(PVector tl) {
    // First constrain width and height of new rectangles based on existing rectangles 
    PVector dimensions = new PVector(width - tl.x, height - tl.y);
    dimensions.x = min(max_width, dimensions.x);
    dimensions.y = min(dimensions.x / min_ratio, dimensions.y);
    constrainFromExistingRectangles(tl, dimensions);
  
    // Now look at constraints from edges of polygon
    Constraints ctl = getConstraints(tl);
    if (ctl.east.i >= 0 && ctl.east.val > 0) { 
      constrainFromPolygonEast(tl, ctl, dimensions);
    }
  
    // For south, check both tl and tr
    if (ctl.south.i >= 0 && ctl.south.val > 0) {
      constrainFromPolygonSouth(tl, ctl, dimensions);
    }
    PVector tr = new PVector(tl.x + dimensions.x, tl.y);
    Constraints ctr = getConstraints(tr);
    if (ctl.south.i >= 0 && ctr.south.val > 0) {
      constrainFromPolygonSouth(tr, ctr, dimensions);
    }
  
    //Adjust based on ratio range of width & height
    if (dimensions.y > dimensions.x / min_ratio)
      dimensions.y = dimensions.x / random(min_ratio, max_ratio);
    else if (dimensions.y < dimensions.x / max_ratio)
      dimensions.x = dimensions.y * max_ratio;
    if (dimensions.y < min_height)
      return false;
  
    // Pick a word & adjust width by ratio of selected word
    float current_ratio = dimensions.x / dimensions.y;
    int index = ws.getRandomWordIndex(current_ratio);
    dimensions.x = dimensions.y * ws.ratios[index];
  
    // Bounding box of word
    Rectangle box = new Rectangle(tl.x, tl.y, dimensions.x, dimensions.y);
    if (poly.contains(box.tr) && poly.contains(box.br) && poly.contains(box.bl)
        && !verticesInsideRectangle(poly.vertices, box)) {
        
          Word w = new Word(index, dimensions.y, tl);
          words.add(w);
          return true;
    }
    return false;
  }
  
  Constraints getConstraints(PVector p) {
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
  
  void constrainFromExistingRectangles(PVector tl, PVector dimensions) {
    for (Word w : words) {
      Rectangle r = w.boundingBox;
      if ((r.getMinY() > tl.y) && (r.getMaxX() > tl.x))
        dimensions.y = min(dimensions.y, r.getMinY() - tl.y);
      else if ((r.getMinX() > tl.x) && (r.getMaxY() > tl.y))
        dimensions.x = min(dimensions.x, r.getMinX() - tl.x);
    }
  }
 
  void constrainFromPolygonEast(PVector tl, Constraints ctl, PVector dimensions) {
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
      Constraints cbl = getConstraints(bl);
      PVector tr = new PVector(tl.x + x_dist, tl.y);
      Constraints ctr = getConstraints(tr);
    
      if (cbl.east.val > 0)
        dimensions.x = min(dimensions.x, min(x_dist, cbl.east.val));
      if (ctr.south.val > 0)
        dimensions.y = min(dimensions.y, min(y_dist, ctr.south.val));
    }
  }
  
  void constrainFromPolygonSouth(PVector p, Constraints cp, PVector dimensions) {
    Segment s = poly.segments[cp.south.i];
    dimensions.y = min(dimensions.y, cp.south.val);
    Rectangle r = new Rectangle(p.x, p.y, dimensions.x, dimensions.y);
    if (r.contains(s.a)) {
      dimensions.y = s.a.y - p.y;
    } else if (r.contains(s.b)) {
      dimensions.y = s.b.y - p.y;
    }
  }

  boolean verticesInsideRectangle(PVector[] vertices, Rectangle r) {
    for (int i = 0; i < vertices.length; i++) {
      if (r.contains(vertices[i]))
        return true;
    }
    return false;
  }
  
}