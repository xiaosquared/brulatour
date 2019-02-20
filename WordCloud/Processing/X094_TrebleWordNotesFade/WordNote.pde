class WordNote {
  String text;
  float font_size;
  NoteGroup notes;
  float opacity = 255; 
  
  public WordNote(String text, float font_size, float start_x) {
    this.text = text;
    this.font_size = font_size;
    textSize(font_size);
    notes = new NoteGroup(textWidth(text), start_x);
  }
  
  public void update() {
    notes.update();
  }
  
  public void fade() {
    Ani.to(this, 7, "opacity", 0);
  }
  
  public void draw(SineStaff staff) {

    notes.draw(staff, false, true, opacity);
    
    PVector text_origin = notes.connectorStart();
    fill(230, opacity);
    textSize(font_size);
    
    pushMatrix();
    float y_adjust = notes.staffAbove ? 0 : 10;
    translate(text_origin.x, text_origin.y + y_adjust);
    //rotate(random(-PI/6, PI/6));
    //rotate(notes.getFirstLastAngle());
    text(text, 0, 0);
    popMatrix();
  }
}