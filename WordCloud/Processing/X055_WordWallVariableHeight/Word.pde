class Word {
  String text;
  float width_height_ratio;
  
  Word(String text) {
    this.text = text;
    
    // find width to height ratio
    textSize(default_font_size);
    width_height_ratio = textWidth(text)/default_font_size;
  }
  
  float getRatio() {
    return width_height_ratio;
  }
  
  void draw(float x, float y, float font_size) {
    textSize(font_size);
    text(text, x, y);
  }
}