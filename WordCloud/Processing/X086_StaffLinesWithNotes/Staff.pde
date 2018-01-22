public class SineTerm {
  private float amplitude;
  private float waveLength;
  private float phaseDifference;

  public SineTerm(float amplitude, float waveLength, float phaseDifference) {
    this.amplitude = amplitude;
    this.waveLength = waveLength;
    this.phaseDifference = phaseDifference;
  }

  public float evaluate(float x) {
    return amplitude * (float) Math.sin(2 * Math.PI * x / waveLength + phaseDifference);
  }
}

public class StaffLines {
  PVector origin;
  float angle;
  
  float trans_x = 0;
  float x_offset = 0;
  float y_offset = 30;
  
  float staff_width;
  float taper_width = 600;
  
  SineTerm[] sine_terms;
  PVector[] staff_positions;
  ArrayList<Note> notes; // TODOOOO
  
  public StaffLines() {
    this(new PVector(100, 450), width, 200, -PI/20);
  }
  
  public StaffLines(PVector origin, float width, float height, float angle) {
    this.origin = origin;
    this.angle = angle;
    staff_width = width;
    
    y_offset = height/4;
    
    resetSineTerms();
    staff_positions = new PVector[5];
    for (int i = 0; i < 5; i++)
      staff_positions[i] = new PVector(0, 0);
      
    notes = new ArrayList<Note>();  
  }
  
  Note addRandomNote() {
    Note n = new Note(NoteName.getRandomNote(), origin.x);
    notes.add(n);
    return n;
  }
  
  void resetSineTerms() {
    sine_terms = new SineTerm[5];
    for (int i = 0; i < 5; i++) {
      SineTerm st = new SineTerm(random(0.1, 0.2), random(50, 120), random(0, TAU));
      sine_terms[i] = st;
    }
  } 
 
  float evaluateSineTerms(float x) {
    float y = 0;
    for (int i = 0; i < 5; i++) {
      y+=sine_terms[i].evaluate(x);
    }
    println(y);
    return y;
  }
 
  public void update() {
    trans_x ++;
    
    for (Note n : notes)
      n.update();
  }
 
  public void draw() {
    pushMatrix();
    rotate(angle);
    translate(trans_x, origin.y);
    
    float y = 0;
    for (float i = origin.x; i < staff_width; i++) {
      float x = i - trans_x;
       
      // figure out taper 
      float tx = x + trans_x - origin.x;
      float taper = 1;
      if (tx < taper_width)
        taper = tx/taper_width;
      
      // get y values by evaluating and summing the sines
      for (int k = 0; k < 5; k++) {
        y += sine_terms[k].evaluate(x/4);
      }
      
      float bw = 20 + taper * 180;
      fill(bw);
      stroke(bw);
      strokeWeight(1);
      
      // get the staff positions
      for (int index = 0; index < 5; index++) { 
        staff_positions[index].x = x + x_offset;
        staff_positions[index].y = y - ((index-2) * y_offset * taper);
        if (i % 4 == 0)
          ellipse(staff_positions[index].x, staff_positions[index].y, 1, 1);
      }
      
      // draw notes
      for (Note note : notes) {
        if (i == note.x()) {
          float note_diameter = abs((y - (5 * y_offset)*taper) - (y - (4 * y_offset)*taper));
          noStroke();
          note.draw(this, note_diameter);
        }
      }
    }
    popMatrix();
  }
}