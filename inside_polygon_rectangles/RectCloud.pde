//A cloud of rectangles

class RectCloud {
  ArrayList<Rectangle> bounding_boxes;
 
  RectCloud() {
    bounding_boxes = new ArrayList<Rectangle>();
  }
  
  void add(Rectangle r) {
    bounding_boxes.add(r);
  }
  
  Rectangle getRect(int i) {
    return bounding_boxes.get(i);
  }
  
  boolean contains(float x, float y) {
    for (Rectangle r : bounding_boxes) {
      if (r.contains(x, y))
        return true;
    }
    return false;
  }
  
  boolean contains(PVector p) {
    return contains(p.x, p.y);
  }
  
  void clear() {
    bounding_boxes.clear();
  }
}