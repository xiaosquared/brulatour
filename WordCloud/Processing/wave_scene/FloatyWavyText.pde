class FloatyWavyText extends WavyText {
  boolean inWater = false;
  PVector acc;
  float text_width;
  
  Wave target_wave;
  float[] prev_heights;
  float lifespan = 8;
  float opacity = 1;  // 0 is transparent;
  
  
  FloatyWavyText(String t, float fs, float x, float y, Wave target_wave) {
    super(t, fs, x, y);
    acc = g.copy();
    vel = new PVector(0, 5);
    
    textSize(fs);
    text_width = textWidth(t);
    this.target_wave = target_wave;
    if (text_width + start_pos.x > width)
      start_pos.x = width - text_width - random(text_width);
    
    
    prev_heights = new float[len];
    for (int i = 0; i < len; i++) {
      prev_heights[i] = 0;
    }
  }
  
  boolean hittingWater() {
    return start_pos.y >= target_wave.target_height && !inWater;
  }
  
  void hitWater() {
    // effect on word
    inWater = true;
    vel.x = random(-1, 1);
    Ani.to(this, lifespan, 1.5, "opacity", 0, Ani.QUAD_IN_OUT);
   
    // effect on wave
    int left = target_wave.getSelectedSpringIndex((int)start_pos.x);
    int right = target_wave.getSelectedSpringIndex((int) (start_pos.x + text_width));
    target_wave.perturbRegion(left, right, start_pos.y + font_size/4, sp);
  }
   
  void reset() {
    opacity = 1;
    inWater = false;
    lifespan = random(5, 10);
    start_pos.y = -200;
    vel.y = 5;
    acc = g.copy();
  }
   
  void update() {
    PVector pos = start_pos.copy();
    
    if (inWater) {
      // Buoyancy force
      float submerged = (pos.y - target_wave.target_height + font_size/2) * text_width;
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
    textSize(font_size);
    if (inWater) {
      drawWavyText(target_wave.springs, target_wave.radius *2);
    }
    else 
      text(text, start_pos.x, start_pos.y);
  }
  
  void drawWavyText(Spring[] springs, float particle_width) {
    textSize(font_size);
    fill(200, 255*opacity);
    
    float caret_x = 0;
    int l_spring, r_spring, c_spring;
    
    for (int i = 0; i < len; i++) {
      char next_letter = text.charAt(i);
      float x = start_pos.x - springs[0].pos.x + caret_x;
      float letter_width = textWidth(next_letter);
      
      // get springs corresponding to Left, Right, and Center ofletter
      l_spring = (int) (x / (particle_width));
      r_spring = (int) ((x + letter_width) / (particle_width));
      c_spring = (int) ((l_spring + r_spring)/2);
      
      if (l_spring < 0 || r_spring >= springs.length) {
        vel.x = -vel.x;
        return;
      }
      
      // take the average of 3 springs
      float avg_spring_height = (springs[l_spring].getHeightDiff() +
                                springs[r_spring].getHeightDiff() +
                                springs[c_spring].getHeightDiff())/3;
      
      // then average it with previous 
      float new_height = 0.5 * avg_spring_height + 0.5 * prev_heights[i];
      prev_heights[i] = new_height;
      
      float y = start_pos.y + new_height;
      
      text(next_letter, x + springs[0].pos.x, y);
      caret_x += letter_width;
    }
  }
}