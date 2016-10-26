class FloatyWavyText extends WavyText {
  boolean inWater = false;
  
  PVector acc;
  float text_width;
  
  FloatyWavyText(String t, float fs, float x, float y) {
    super(t, fs, x, y);
    acc = g.copy();
    vel = new PVector(0, 5);
    
    textSize(fs);
    text_width = textWidth(t);
  }
  
  void update() {
    PVector pos = start_pos.copy();
    if (inWater) {
      // Buoyancy force
      float submerged = (pos.y - water_level + font_size/2) * text_width;
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
    text(text, start_pos.x, start_pos.y);
    
    //super.draw(w.springs, w.radius *2);
  }
}