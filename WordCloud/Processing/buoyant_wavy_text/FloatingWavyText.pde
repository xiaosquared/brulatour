class FloatingWavyText {
  String text;
  int text_length;
  int font_size;
  
  PVector pos;
  PVector vel;
  PVector acc;
  float w, h;
  float bounce = 0.5;
  
  boolean inWater = false;
  int first_spring;
  int[] ctrl_springs;
  
  FloatingWavyText(float x, float y, String t, int fs) {
    text = t;
    text_length = t.length();
    this.font_size = fs;
    
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = g.copy();
    
    h = font_size;
    w = textWidth(t);
  }
  
  void assignSprings(float spring_radius) {
    ctrl_springs = new int[text_length];
    
    textSize(font_size);
    float caret_x = 0;
    PVector start_pos = new PVector(pos.x - w/2, pos.y - h/2);
    
    for (int i = 0; i < text_length; i++) {
      char curr_letter = text.charAt(i);
      float curr_width = textWidth(curr_letter);
      
      caret_x += curr_width;
      int s_id = ceil((start_pos.x + caret_x) / (spring_radius * 2));
      
      if (i == 0) {
        first_spring = s_id;
        ctrl_springs[i] = 0;
      } else {
        ctrl_springs[i] = s_id - first_spring;
      }
    }
    
  }
  
  void update() {
    if (inWater) {
      // Buoyancy force
      float submerged = (pos.y - water_level + h/2) * w;
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
  }
  
  void draw(Spring[] springs) {
    fill(200);
    textSize(font_size);
    if (ctrl_springs != null) {
      textAlign(LEFT);
      float caret_x = 0;
      float start_x = pos.x - w/2;
      for (int i = 0; i < text_length; i++) {
        char next_letter = text.charAt(i);
        float y = pos.y + h/2 + springs[ctrl_springs[i]+first_spring].getHeightDiff()*bounce;
        float x = start_x + caret_x;
        
        text(next_letter, x, y);
        caret_x += textWidth(next_letter);
      }
    }
    else {
      textAlign(CENTER);
      text(text, pos.x, pos.y + h/2);
    }
  }
}