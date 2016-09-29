class WavyText {
  String text;
  int len;
  int font_size;
  
  PVector start_pos;
  int spring_offset;
  int[] ctrl_springs;
  
  WavyText(String t, int fs, float x, float y) {
    text = t;
    len = t.length();
    start_pos = new PVector(x, y);
    font_size = fs;
    
    ctrl_springs = new int[len];
  }
  
  // returns the index of the last spring
  int assignSprings(float spring_width, int numSprings) {
    textSize(font_size);
    float caret_x = 0;
    int selected_spring = 0;
    for (int i = 0; i < len; i++) {
      char curr_letter = text.charAt(i);
      float curr_width = textWidth(curr_letter);
      
      caret_x += curr_width;
      selected_spring = (int) ((start_pos.x + caret_x) / spring_width);
      if (selected_spring >= numSprings)
        return selected_spring;
      ctrl_springs[i] = selected_spring; 
    }
    return selected_spring;
  }
  
  void draw(Spring[] springs) {
    stroke(200);
    textSize(font_size);
    float caret_x = 0;
    for (int i = 0; i < len; i++) {
      char next_letter = text.charAt(i);
      float y = start_pos.y + springs[ctrl_springs[i]].getHeightDiff();
      float x = start_pos.x + caret_x;
      text(next_letter, x, y);
      caret_x += textWidth(next_letter);
    }
  }
}