class SineStaff {
  ArrayList<SineWave> lines;
  int main_line_id = 2;
  float taper_width = 300;
  float y_space;
  
  float min_taper = 0;
  
  public SineStaff(PVector origin, float width, float height) {
    lines = new ArrayList<SineWave>();
    SineWave main_line = new SineWave(origin, width); 
    
    for (int i = 0; i < 5; i++) {
      if (i != main_line_id) {
        y_space = height / 4; 
        //float y = origin.y - ((i - 2) * y_space);
        //SineWave sw = new SineWave(origin.x, y, width, main_line.getSineTerms());
        SineWave sw = new SineWave(origin.x, origin.y, width, main_line.getSineTerms());
        lines.add(sw);
      }
      else 
        lines.add(main_line);
    }
  }
  
  public void initText(String[] words, float font_size) {
    for (SineWave line : lines) {
      line.initText(words, font_size);
    }
    float text_height = font_size *5;
    float total_height = text_height + y_space * 4;
    min_taper = text_height/total_height;
  }
  
  public void update() {
    SineWave main = lines.get(main_line_id);
    main.update();
    for (int i = 0; i < 5; i++) {
      if (i != main_line_id) {
        SineWave side_line = lines.get(i);
        for (int pos = 0; pos < main.positions.length; pos++) {
          
          // taper
          float taper = 1;
          if (pos < taper_width) {
            taper = min_taper + pos/taper_width;
          }
          taper = min(taper, 1);
         
          
          float y_offset = ((i - 2) * y_space * taper);
          side_line.positions[pos].y = main.positions[pos].y - y_offset;
        }
      }
    }
  }
  
  public void draw() {
    for (SineWave line : lines) {
      line.draw(taper_width);
    }
  }
}