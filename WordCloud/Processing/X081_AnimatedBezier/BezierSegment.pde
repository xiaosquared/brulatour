class BezierSegment {
  PShape bez;
  BPoint a0;
  BPoint c0;
  BPoint c1;
  BPoint a1;
  
  public BezierSegment(BPoint a0, BPoint c0, BPoint c1, BPoint a1) {
    this.a0 = a0;
    this.c0 = c0;
    this.c1 = c1;
    this.a1 = a1;
    
    bez = createShape();
    bez.beginShape();
    bez.vertex(a0.x(), a0.y());
    bez.bezierVertex(c0.x(), c0.y(), c1.x(), c1.y(), a1.x(), a1.y());
    bez.endShape();
  }
  
  public PShape getPShape() { return bez; }
  public BPoint a0() { return a0; } public BPoint c0() { return c0; }
  public BPoint c1() { return c1; } public BPoint a1() { return a1; }
  
  public float a0x() { return a0.x(); } public float c0x() { return c0.x(); }
  public float c1x() { return c1.x(); } public float a1x() { return a1.x(); }
  
  public float a0y() { return a0.y(); } public float c0y() { return c0.y(); }
  public float c1y() { return c1.y(); } public float a1y() { return a1.y(); }
}