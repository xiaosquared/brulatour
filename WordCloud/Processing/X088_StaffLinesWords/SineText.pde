public class SineText {
  String text;
  int len;
  float font_size;
  
  PVector start_pos;
  int start_pos_index;
  
  public SineText(String t, float fs, int start) {
    text = t;
    len = t.length();
    font_size = fs;
    
    start_pos_index = start;
    println(start);
    //PVector start_pos = new PVector(x, y);
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
      text(next_letter, x, y);
      caret_x += textWidth(next_letter);
    }
  }
}


//float x = start_pos.x - positions[0].x + caret_x;