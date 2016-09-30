class WavyText {
  String text;
  int len;
  int font_size;
  
  PVector start_pos;
  PVector vel;
  
  WavyText(String t, int fs, float x, float y) {
    text = t;
    len = t.length();
    font_size = fs;
    
    start_pos = new PVector(x, y);
    vel = new PVector(2, 0);
  }
  
  void update() {
    start_pos.add(vel);
  }
  
  void draw(Spring[] springs, float spring_width) {
    textSize(font_size);
    
    float caret_x = 0;
    int selected_spring = 0;
    
    for (int i = 0; i < len; i++) {
      char next_letter = text.charAt(i);
      float x = start_pos.x - springs[0].pos.x + caret_x;
      
      // find the spring associated with the letter
      selected_spring = (int) (x / spring_width);
      if (selected_spring >= springs.length || selected_spring < 0) {
        vel.x = -vel.x;
        return;
      }
      
      float y = start_pos.y + springs[selected_spring].getHeightDiff();
      text(next_letter, x + springs[0].pos.x, y);
      caret_x += textWidth(next_letter);
    }
  }
}