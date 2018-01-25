class BezierCurve {
  
  ArrayList<BPoint> points;
  boolean bViewControlPts = true;
  boolean bViewCurve = true;
  
  ArrayList<BezierLetter> letters;  
  int letters_index = 0;
  boolean animateVisibility = false;
    
  public BezierCurve(float x, float y) {
    points = new ArrayList<BPoint>();
    points.add(new BPoint(x, y, true));
    
    letters = new ArrayList<BezierLetter>();
  }

  public BezierCurve(BPoint a0) {
    points = new ArrayList<BPoint>();
    points.add(a0);
    letters = new ArrayList<BezierLetter>();
  }

  public BezierCurve(ArrayList<BPoint> points) {
    this.points = points;
    letters = new ArrayList<BezierLetter>();
  }

  public void scale(float factor) {
    for (BPoint pt : points) {
      pt.setX(pt.x() * factor);
      pt.setY(pt.y() * factor);
    }
  }

  public void zeroOrigin() {
    float origin_x = points.get(0).x();
    float origin_y = points.get(0).y();
    for (BPoint pt : points) {
      pt.setX(pt.x() - origin_x);
      pt.setY(pt.y() - origin_y);
    }
  }

  public void clearLetters() { letters.clear(); }

  public void setLettersVisibility(boolean b) {
    for (BezierLetter l : letters)
      l.setVisibility(b);
  }

  public boolean animateVisibility() {
   if (letters_index < letters.size()) {
     letters.get(letters_index).setVisibility(true);
     
     letters_index++;
     if (letters_index == letters.size())
       return true;
   }
   return false;
  }

  public void fillWithLetters(String phrase) { fillWithLetters(phrase, 16); }

  public void fillWithLetters(String phrase, float font_size) {
    float size = font_size;
    int letter_index = 0;
    
    ArrayList<BezierSegment> segments = getBezierSegments();
    
    BezierSegment s0 = segments.get(0);
    float tx = bezierTangent(s0.a0x(), s0.c0x(), s0.c1x(), s0.a1x(), 0);
    float ty = bezierTangent(s0.a0y(), s0.c0y(), s0.c1y(), s0.a1y(), 0);
    float angle = atan2(ty, tx);
    float current_length = 0;
    float segment_length = 0;
    
    int count = 0;
    
    for (BezierSegment s : segments) {
      if (current_length > 0) 
        current_length -= segment_length;
      segment_length = (float) bezLength(s.getPShape(), 0.001);
      
      //println("SEGMENT : " + count);
      while (current_length < segment_length) {
        char l = phrase.charAt(letter_index); 
        float t = current_length / segment_length;
        float x = bezierPoint(s.a0x(), s.c0x(), s.c1x(), s.a1x(), t);
        float y = bezierPoint(s.a0y(), s.c0y(), s.c1y(), s.a1y(), t);
        
        tx = bezierTangent(s.a0x(), s.c0x(), s.c1x(), s.a1x(), t);
        ty = bezierTangent(s.a0y(), s.c0y(), s.c1y(), s.a1y(), t);
        float new_angle = atan2(ty, tx);
        
        // this part prevents the letters from getting huge after a discontinuity
        // of angle between segments
        float letter_size;
        if (count > 0) {
          float angle_diff = new_angle - angle;
          println(angle_diff);
          if (abs(angle_diff) > 0.15)
            letter_size = size;
          else { 
            float size_diff = (new_angle-angle) * 50; // TODO adjust this factor
            letter_size = size_diff > 0 ? size + size_diff : size - size_diff;
          }
        } 
        else
          letter_size = size;
        
        letters.add(new BezierLetter(l, letter_size, x, y, new_angle));
        //textSize(letter_size);
        
      
        current_length += textWidth(l) * 1.1;
        letter_index ++; letter_index %= phrase.length();
        angle = new_angle;
      }
      count++;
    }
  }

  public boolean isEmpty() { return points.size() == 0; }

  public void addSegment(BPoint c1, BPoint c2, BPoint a) {
    points.add(c1);
    points.add(c2);
    points.add(a);
  }
  
  public BPoint getSelectedPoint(float x, float y, float radius) {
    for (BPoint p : points ) {
      if (dist(x, y, p.x(), p.y()) < radius)
        return p;
    }
    return null;
  }
  
  public void deleteAllFollowing(BPoint p) {
    for (int i = 0; i < points.size(); i++) {
      if (p.equals(points.get(i))) {
         int index = i - i%4;
         points.subList(index, points.size()).clear();
         return;
      }
    }
  }
  
  public void viewControlPts(boolean b) { bViewControlPts = b; }
  public void toggleViewControlPts() { bViewControlPts = !bViewControlPts; }
  public void viewCurve(boolean b) { bViewCurve = b; }
  public void toggleViewCurve() { bViewCurve = !bViewCurve; }
  
  public void drawLetters() {
    for (BezierLetter l : letters) {
      l.draw();
    }
  }
  
  public void draw() {
    if (points.size() == 0)
      return;
    
    if (points.size() == 1) {
      points.get(0).draw();
      return;
    }
    
    fill(255);
    drawLetters();
    
    
    if (bViewCurve) {
      beginShape();
    }
      BPoint a0 = points.get(0);
      if (bViewControlPts)
        a0.draw();
      if (bViewCurve) {  
        vertex(a0.x(), a0.y());
      }
      
    for (int i = 1; i < points.size(); i +=3 ) {
      BPoint c0 = points.get(i);
      BPoint c1 = points.get(i+1);
      BPoint a1 = points.get(i+2);
      
      // curve
      if (bViewCurve) {
        bezierVertex(c0.x(), c0.y(), c1.x(), c1.y(), a1.x(), a1.y());
      }
      
      // control lines
      if (bViewControlPts) {
        stroke(100);
        line(a0.x(), a0.y(), c0.x(), c0.y());
        line(a1.x(), a1.y(), c1.x(), c1.y());
      
        // points
        a1.draw();
        c0.draw();
        c1.draw();
      }
      a0 = a1;
    }
    strokeWeight(1);
    stroke(255);
    noFill();
    if (bViewCurve) {
      endShape();
    }
  }
  
  // also prints out angles at anchors
  float getLength() {
    float len = 0;
    ArrayList<BezierSegment> segments = getBezierSegments();
    for (BezierSegment s : segments) {
      PShape bez = s.getPShape();
      len += (float) bezLength(bez, 0.001);
    }
    return len;
  }
  
  ArrayList<BezierSegment> getBezierSegments() {
    ArrayList<BezierSegment> segments = new ArrayList<BezierSegment>();
    if (points.size() <= 1)
      return segments;
    
    for (int i = 0; i < points.size() - 3; i+= 3) {
      BPoint a0 = points.get(i);
      BPoint c0 = points.get(i+1);
      BPoint c1 = points.get(i+2);
      BPoint a1 = points.get(i+3);
      segments.add(new BezierSegment(a0, c0, c1, a1));
    }
    return segments;
  }
  
  double bezLength(PShape bez, float error){
    double[] myBezLength = new double[1]; //we want this to get passed as a reference so we put it in an array :)
    PVector[] bezPts = new PVector[bez.getVertexCount()];
    for( int i=0; i<bez.getVertexCount(); i++){
      bezPts[i] = new PVector( bez.getVertex(i).x, bez.getVertex(i).y );
    }
    
    addIfClose( bezPts, myBezLength,  error );
    
    return myBezLength[0];
  }


  void bezSplit(PVector[] v, PVector[] left, PVector[] right){
  
    ArrayList<PVector[]> vTemp = new ArrayList<PVector[]>();
    for( int g=0; g<4; g++){
      vTemp.add(new PVector[4]); 
      for(int h=0; h<4; h++){
        vTemp.get(g)[h] = new PVector(0, 0);  
      }
    }
    //copy control points
    PVector[] ctrlPts = new PVector[4];
    for( int i=0; i<=3; i++ ){
       ctrlPts[i] = new PVector(v[i].x, v[i].y); 
    }
    vTemp.set(0, ctrlPts );
  
    /* Triangle computation */
    for (int j = 1; j <= 3; j++) {  
      for (int k =0 ; k <= 3 - j; k++) {
          PVector tri = new PVector(  0.5 * vTemp.get(j-1)[k].x + 0.5 * vTemp.get(j-1)[k+1].x, 
                                      0.5 * vTemp.get(j-1)[k].y + 0.5 * vTemp.get(j-1)[k+1].y);
          vTemp.get(j)[k] = tri;   
      }                                      
    }                                       
  
    for (int l = 0; l <= 3; l++){ 
      left[l] = vTemp.get(l)[0];
    }
    
    for (int m = 0; m <= 3; m++){ 
      right[m] = vTemp.get(3-m)[m];
    }
  }                                           
 
  void addIfClose( PVector[] v, double[] myBezLength, float error){
  
    PVector[] left = new PVector[4], right = new PVector[4];
    double len=0, chord=0;
  
    for (int i=0; i<=2; i++ ){
      len += dist(v[i].x, v[i].y, v[i+1].x, v[i+1].y);    
    }
  
    chord = dist(v[0].x, v[0].y, v[3].x, v[3].y);
  
    if( len-chord > error ){
      bezSplit(v, left, right);
      addIfClose(left, myBezLength, error);
      addIfClose(right, myBezLength, error);
      return;
    }
  
    myBezLength[0] += len;
  }
  
  public void print() {
    for (BPoint pt : points) {
       pt.print();
    }
  }
}