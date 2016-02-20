static class Utils {

  /** 
  * @return true if a vertical line at p.x intersects with segment s
  */
  static boolean crossVertical(PVector p, Segment s) {
    if (p.x < min(s.a.x, s.b.x) || p.x > max(s.a.x, s.b.x))
      return false;
    return true;
  }
  
  /** 
  * @return true if a horizontal line at y intersects with segment s
  */
  static boolean crossHorizontal(PVector p, Segment s) {
    if (p.y < min(s.a.y, s.b.y) || p.y > max(s.a.y, s.b.y))
      return false;
    return true;
  }
  
  /** 
  * @return vertical distance between point p & line segment s
  */
  static float crossingDistanceVertical(PVector p, Segment s) {
    if (p.x < min(s.a.x, s.b.x) || p.x > max(s.a.x, s.b.x))
      return -1;
    float m = (s.a.y - s.b.y) / (s.a.x - s.b.x);
    float y = m * (p.x - s.a.x) + s.a.y;  
    
    return y - p.y;
  }
  
  /** 
  * @return horizontal distance between point p & line segment s
  */
  static float crossingDistanceHorizontal(PVector p, Segment s) {
    if (p.y < min(s.a.y, s.b.y) || p.y > max(s.a.y, s.b.y))
      return -1;
    float minv = (s.a.x - s.b.x) /(s.a.y - s.b.y) ;
    float x = minv * (p.y - s.a.y) + s.a.x;
    
    return x - p.x;
  }
  
}