static class Utils {
  
  /** 
  * @return min distance between point p & line segment vw
  */
  static float distPointSegment(PVector p, PVector v, PVector w) {
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
  

  /** 
  * @return vertical distance between point p & line segment vw
  */
  static float distPointSegmentVertical(PVector p, PVector v, PVector w) {
    if (p.x < min(v.x, w.x) || p.x > max(v.x, w.x))
      return -1;
    float m = (v.y - w.y) / (v.x - w.x);
    float y = m * (p.x - v.x) + v.y;  
    
    return y - p.y;
  }
  
  /** 
  * @return horizontal distance between point p & line segment vw
  */
  static float distPointSegmentHorizontal(PVector p, PVector v, PVector w) {
    if (p.y < min(v.y, w.y) || p.y > max(v.y, w.y))
      return -1;
    float minv = (v.x - w.x) /(v.y - w.y) ;
    float x = minv * (p.y - v.y) + v.x;
    
    return x - p.x;
  }
  
  /////////////////////////////////////////////////////////////////////////
  // Not used now but might use later. Consider getting rid of...
  
  /** 
  * @return true if a vertical line at p.x intersects with segment vw
  */
  static boolean crossVertical(PVector p, PVector v, PVector w) {
    if (p.x < min(v.x, w.x) || p.x > max(v.x, w.x))
      return false;
    return true;
  }
  
  /** 
  * @return true if a horizontal line at y intersects with segment vw
  */
  static boolean crossHorizontal(PVector p, PVector v, PVector w) {
    if (p.y < min(v.y, w.y) || p.y > max(v.y, w.y))
      return false;
    return true;
  }
  
}