public class SineText {
  String text;
  int len;
  float font_size;
  
  int start_pos_index;
  
  public SineText(String t, float fs, int start) {
    text = t;
    len = t.length();
    font_size = fs;
    
    start_pos_index = start;
  }
  
  public void draw(PVector[] positions) {
    draw(positions, 0);
  }
  
  public void draw(PVector[] positions, float taper_width) {
    textSize(font_size);
    
    float caret_x = 0;
    int selected = 0;
    for (int i = 0; i < len; i++) {
      char next_letter = text.charAt(i);
      selected = start_pos_index + (int) caret_x;
      
      // find the position associated with the letter
      if (selected >= positions.length) { return; }
      float x = positions[selected].x;
      float y = positions[selected].y;
      
      if (i + start_pos_index <= taper_width) {
          float shade = (float) (i+start_pos_index)/taper_width * 100;
          fill(shade + 50);
      } else {
          fill(150);
      }
        
      text(next_letter, x, y);
      caret_x += textWidth(next_letter);
    }
  }
}