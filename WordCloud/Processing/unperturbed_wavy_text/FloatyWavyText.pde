class FloatyWavyText {
  String text;
  int len;
  float font_size;
  
  PVector start_pos;
  PVector vel;
  PVector acc;
  
  boolean inWater = false;
  float text_width;
  
  float[] prev_heights;
  
  FloatyWavyText(String t, float fs, float x, float y) {
    text = t;
    len = t.length();
    font_size = fs;
    start_pos = new PVector(x, y);
    vel = new PVector(0, 5);
    acc = g.copy();
    
    textSize(fs);
    text_width = textWidth(t);
    
    prev_heights = new float[len];
    for (int i = 0; i < len; i++) {
      prev_heights[i] = 0;
    }
  }
  
  boolean hittingWater() {
    return start_pos.y >= 350 && !inWater;
  }
  
  void hitWater() {
    inWater = true;
    vel.x = random(-3, 2);
  }
  
  void update() {
    PVector pos = start_pos.copy();
    if (inWater) {
      // Buoyancy force
      float submerged = (pos.y - 350 + font_size/2) * text_width;
      float buoy = - submerged * water_density * g.y;
      
      // Drag
      float drag = 0.06 * vel.y * vel.y;
      if (vel.y > 0)
        drag = - drag;
      
      // total force
      acc.y = g.y + drag + buoy;
    }
    vel.add(acc);
    pos.add(vel);
    
    start_pos = pos;
  }
  
  void draw() {
    fill(200);
    //text(text, start_pos.x, start_pos.y);
    superDraw();
  }
  
  void superDraw() {
    textSize(font_size);
    
    float caret_x = 0;
    int l_spring;
    int r_spring;
    int c_spring;
    
    for (int i = 0; i < len; i++) {
      char next_letter = text.charAt(i);
      float x = start_pos.x - w.springs[0].pos.x + caret_x;
      float letter_width = textWidth(next_letter);
      
      // find the 3 springs associated with the letter
      l_spring = (int) (x / (w.radius*2));
      r_spring = (int) ((x + letter_width) / (w.radius*2));
      c_spring = (int) ((l_spring + r_spring)/2);
      
      if (l_spring < 0 || r_spring >= w.springs.length) {
        vel.x = -vel.x;
        return;
      }
      
      float avg_spring_height = (w.springs[l_spring].getHeightDiff() +
                                w.springs[r_spring].getHeightDiff() +
                                w.springs[c_spring].getHeightDiff())/3;
      
      float new_height = 0.5 * avg_spring_height + 0.5 * prev_heights[i];
      prev_heights[i] = new_height;
      
      float y = start_pos.y + new_height;
      text(next_letter, x + w.springs[0].pos.x, y);
      caret_x += letter_width;
    }
  }
  
  // this should go in wave
  boolean inWave(int i) {
    return i < w.springs.length && i > 0;
  }
}