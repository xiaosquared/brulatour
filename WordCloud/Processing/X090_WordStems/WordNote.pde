class WordNote {
  String text;
  float font_size;
  NoteGroup notes;
  
  public WordNote(String text, float font_size, float start_x) {
    this.text = text;
    this.font_size = font_size;
    textSize(font_size);
    notes = new NoteGroup(textWidth(text), start_x);
  }
  
  public void update() {
    notes.update();
  }
  
  public void draw(SineStaff staff) {
    notes.draw(staff, false, true);
    
    
    PVector text_origin = notes.connectorStart();
    fill(150);
    textSize(font_size);
    text(text, text_origin.x, text_origin.y);
  }
}