static class Utils {
  
  /** 
  * @return min distance between line segment vw & point p
  */
  static float minimumDistance(PVector v, PVector w, PVector p) {
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
}