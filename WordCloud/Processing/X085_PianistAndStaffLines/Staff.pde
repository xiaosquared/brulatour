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
  float origin_x = 280;
  float origin_y = 450;
  
  float trans_x = 0;
  float x_offset = 5;
  float y_offset = 35;
  float r = 2;
  float taper_width = 600;
  
  SineTerm[] sine_terms;
  
  public StaffLines() {
    resetSineTerms();
  }
  
  void resetSineTerms() {
    sine_terms = new SineTerm[5];
    for (int i = 0; i < 5; i++) {
      SineTerm st = new SineTerm(random(0.5, 1.5), random(40, 120), random(0, TAU));
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
  }
 
  public void draw() {
    
    pushMatrix();
    rotate(-PI/20);
    translate(trans_x, origin_y);
    
    float y = 0;
    for (float x = origin_x - trans_x; x < width - trans_x; x+= 6) {
    
      float tx = x+trans_x - origin_x;
      float taper = 1;
      if (tx < taper_width)
        taper = tx/taper_width;
      
      for (int i = 0; i < 5; i++) {
        y += sine_terms[i].evaluate(x/4);
      }
      
      float bw = 20 + taper * 180;
      fill(bw, 0, bw);
      
      ellipse(x + x_offset, y - y_offset * taper, r, r);
      ellipse(x + 2 * x_offset, y - (2 * y_offset)*taper, r, r);
      ellipse(x + 3 * x_offset, y - (3 * y_offset)*taper, r, r);
      ellipse(x + 4 * x_offset, y - (4 * y_offset)*taper, r, r);
      ellipse(x + 5 * x_offset, y - (5 * y_offset)*taper, r, r);  
     }
     
     popMatrix();
   }
}