import java.util.LinkedList;

class SineWave {
  PVector origin;
  float width;
  float trans_x;
  
  SineTerm[] sine_terms;
  PVector[] positions;
  
  LinkedList<SineText> texts;
  float font_size = 0;
  
  boolean drawLine = false;
  
  public SineWave(float x, float y, float width, SineTerm[] sine_terms) {
    this(new PVector(x, y), width, sine_terms);
  }
  
  public SineWave(PVector origin, float width) {
    this.origin = origin;
    this.width = width;
    initPositions();
    initSineTerms();
  }
 
  public SineWave(PVector origin, float width, SineTerm [] sine_terms) {
    this.origin = origin;
    this.width = width;
    this.sine_terms = sine_terms;
    initPositions();
  }
 
  public SineTerm[] getSineTerms() { return sine_terms; } 
 
  private void initPositions() {
    positions = new PVector[floor(width)];
    for (int i = 0; i < width; i++) { 
      PVector p = new PVector(i + origin.x, 0);
      positions[i] = p;
    }
  }
 
  private void initText(String[] words, float fs) {
    font_size = fs;
    texts = new LinkedList<SineText>();
    
    int selected_pos = 0;
    while (selected_pos < width) {
      
      // pick a word
      int w_index = floor(random(words.length));
      String word = words[w_index];
      
      // make the SineText
      SineText st = new SineText(word, font_size, selected_pos);
      float word_width = textWidth(word);
      selected_pos += (int) word_width;
      if (selected_pos < positions.length)
        texts.add(st);
      selected_pos += 5;
    }
  }
  
  public void initSineTerms() {
    int terms = 5;
    sine_terms = new SineTerm[terms];
    for (int i = 0; i < terms; i++) {
      SineTerm st = new SineTerm(random(0.1, 0.2), random(200, 500), random(0, TAU));
      sine_terms[i] = st;
    }
  }
  
  public void update() {
    trans_x --;
    
    float y = 0;
    for (int i = 0; i < width; i++) {
      float x = i + origin.x + trans_x;
      y = evalSines(x, y);
      positions[i].set(x-trans_x, y);
    }
  }
  
  float getTransY() { return origin.y; }
  
  public void draw() { draw(0); }
  
  public void draw(float taper_width) {
    pushMatrix();
    translate(0, origin.y);
    
    if (drawLine) {
      for (int i = 0; i < positions.length; i++) {
        if (i <= taper_width) {
          float shade = (float) i/taper_width * 200;
          stroke(shade); fill(shade);
        } else {
          stroke(200); fill(200);
        }
        PVector p = positions[i];
        ellipse(p.x, p.y, 1, 1);
      }
    }
    
    if (texts != null) {
      for (SineText st : texts) {
        st.draw(positions, taper_width);
      }
    }
    
    popMatrix();
  }
  
  private float evalSines(float x, float y) {
    for (int i = 0; i < sine_terms.length; i++) {
        y += sine_terms[i].evaluate(x);
    }
    return y;
  }
}