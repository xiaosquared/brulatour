// Moves along with a wave, letter by letter 

class WavyText {
  String text;
  int len;
  
  PVector start_pos;
  int font_size;
    
  int[] ctrl_springs; // spring that controls each letter
  
  WavyText(String t, int font_size, float x, float y) {
    text = t;
    len = t.length();
    
    start_pos = new PVector(x, y);
    this.font_size = font_size;
    
    ctrl_springs = new int[len];
    println(ctrl_springs[0]);
  }
  
  void assignSprings(Spring[] springs) {
    textSize(font_size);
    float caret_x = 0;
    for (int i = 0; i < len; i++) {
      char curr_letter = text.charAt(i);
      float curr_width = textWidth(curr_letter);
      
      caret_x += curr_width;
      ctrl_springs[i] = ceil((start_pos.x + caret_x) / springs[0].diameter);
    }
  }
  
  void draw(Spring[] springs) {
    textSize(font_size);
    float caret_x = 0;
    for (int i = 0; i < len; i++) {
      char next_letter = text.charAt(i);
      float y = start_pos.y + springs[ctrl_springs[i]].pos.y;
      float x = start_pos.x + caret_x;
      
      text(next_letter, x, y);
      caret_x += textWidth(next_letter);
    }
  }
}