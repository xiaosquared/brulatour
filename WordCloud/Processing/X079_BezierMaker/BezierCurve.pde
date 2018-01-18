class BPoint {
  PVector pt;
  boolean isAnchor;
  boolean isSelected = false;
    
  public BPoint(float x, float y, boolean isAnchor) {
    pt = new PVector(x, y);
    this.isAnchor = isAnchor;
  }
 
  public float x() { return pt.x; }
  public float y() { return pt.y; }
  public boolean isSelected() { return isSelected; }
  public void setX(float x) { pt.x = x; }
  public void setY(float y) { pt.y = y; }
  public void setSelected(boolean s) { isSelected = s; }
    
  public void draw() {
    if (isSelected)
      strokeWeight(3);
    else
      strokeWeight(1);
    
    if (isAnchor)
      fill(255, 0, 0);
    else
      fill(0, 255, 0);
    ellipse(pt.x, pt.y, 10, 10);
  }
}

class BezierCurve {
  
  ArrayList<BPoint> points;
  boolean bDrawCurveOnly = false;
    
  public BezierCurve(float x, float y) {
    points = new ArrayList<BPoint>();
    points.add(new BPoint(x, y, true));
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
  
  public void drawCurveOnly(boolean cv) { bDrawCurveOnly = cv; }
  public void toggleDrawCurveOnly() { bDrawCurveOnly = !bDrawCurveOnly; }
  
  public void draw() {
    if (points.size() == 0)
      return;
    
    if (points.size() == 1) {
      points.get(0).draw();
      return;
    }
    
    beginShape();
      BPoint a0 = points.get(0);
      if (!bDrawCurveOnly)
        a0.draw();
      vertex(a0.x(), a0.y());
    
    for (int i = 1; i < points.size(); i +=3 ) {
      BPoint c0 = points.get(i);
      BPoint c1 = points.get(i+1);
      BPoint a1 = points.get(i+2);
      
      // curve
      bezierVertex(c0.x(), c0.y(), c1.x(), c1.y(), a1.x(), a1.y());
      
      // control lines
      if (! bDrawCurveOnly) {
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
    endShape();
  }
  
  // also prints out angles at anchors
  float getLength() {
    if (points.size() == 1)
      return 0;
    
    float len = 0;
    for (int i = 0; i < points.size()-3; i+=3) {
      BPoint a0 = points.get(i);
      BPoint c0 = points.get(i+1);
      BPoint c1 = points.get(i+2);
      BPoint a1 = points.get(i+3);
      
      PShape bez = createShape();
      bez.beginShape();
      bez.vertex(a0.x(), a0.y());
      bez.bezierVertex(c0.x(), c0.y(), c1.x(), c1.y(), a1.x(), a1.y());
      bez.endShape();
      
      len += (float) bezLength(bez, 0.001);
      
      // ANGLES PART
      //println("BEZIER SEGMENT: " + i/3);
      //float tx0 = bezierTangent(a0.x(), c0.x(), c1.x(), a1.x(), 0);
      //float ty0 = bezierTangent(a0.y(), c0.y(), c1.y(), a1.y(), 0);
      //float ang0 = atan2(ty0, tx0);
      
      //float tx1 = bezierTangent(a0.x(), c0.x(), c1.x(), a1.x(), 1);
      //float ty1 = bezierTangent(a0.y(), c0.y(), c1.y(), a1.y(), 1);
      //float ang1 = atan2(ty1, tx1);
      //println("Angle at A0: " + degrees(ang0));
      //println("Angle at A1: " + degrees(ang1));
    }
    return len;
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
}