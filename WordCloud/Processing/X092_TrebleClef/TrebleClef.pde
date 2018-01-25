class TrebleClef {
    BezierCurve clef;
    PVector origin;
    
    public TrebleClef(float x, float y) {
      clef = new BezierCurve(new BPoint(610, 436, true));
      addSegment(new PVector(570, 435), new PVector(576, 386), new PVector(605, 382));
      addSegment(new PVector(657.0, 377.0), new PVector(684.0, 457.0), new PVector(620.0, 478.0));
      addSegment(new PVector(535.0, 485.0), new PVector(525.0, 398.0), new PVector(585.0, 309.0));
      addSegment(new PVector(613.0, 251.0), new PVector(596.0, 198.0), new PVector(560.0, 171.0));
      addSegment(new PVector(577.0, 274.0), new PVector(630.0, 532.0), new PVector(640.0, 581.0));
      addSegment(new PVector(641.0, 612.0), new PVector(609.0, 620.0), new PVector(607.0, 586.0));
      clef.zeroOrigin();
      this.origin = new PVector(x, y);
      
      clef.viewControlPts(false);
      clef.viewCurve(false);
      clef.scale(0.5);
      
      clef.fillWithLetters("hello world ", 6);
    }
    
    public TrebleClef(BPoint b) {
      clef = new BezierCurve(b);  
    }
    
    public void addSegment(PVector c0, PVector c1, PVector a1) {
      clef.addSegment(new BPoint(c0, false), new BPoint(c1, false), new BPoint(a1, true));
    }
    
    public void draw() {
      pushMatrix();
      translate(origin.x, origin.y);
      clef.draw();
      popMatrix();
    }
}




//Anchor: 610.0, 436.0

//Pt: 570.0, 435.0
//Pt: 576.0, 386.0
//Anchor: 605.0, 382.0
//Pt: 657.0, 377.0
//Pt: 684.0, 457.0
//Anchor: 620.0, 478.0
//Pt: 535.0, 485.0
//Pt: 525.0, 398.0
//Anchor: 585.0, 309.0
//Pt: 613.0, 251.0
//Pt: 596.0, 198.0
//Anchor: 560.0, 171.0
//Pt: 577.0, 274.0
//Pt: 630.0, 532.0
//Anchor: 640.0, 581.0
//Pt: 641.0, 612.0
//Pt: 609.0, 620.0
//Anchor: 607.0, 586.0