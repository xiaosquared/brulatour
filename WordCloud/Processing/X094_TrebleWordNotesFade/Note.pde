public class Note {
  int line;
  boolean bAboveLine;
  
  float start_x;
  float trans_x = 0;
  PVector last_position = new PVector(0, 0);
  float diameter = 0;
  
  NoteName note;  
  boolean isFilled = false;
  
  
  public Note(NoteName note, float start_x) {
    this.note = note;
    this.start_x = start_x;
    
    this.line = whichLine();
    this.bAboveLine = isOnLine();
  }
  
  public PVector position() { return last_position; }
  
  public void update() {
    //trans_x++;
  }
  
  public float x() { return start_x + trans_x; }
  
  public boolean isOnLine() { 
     return note.isOnLine();
  }
  
  public int whichLine() {
    return note.whichLine();
  }
  
  public int stemDirection() {
    return note.stemDirection();
  }
  
  public boolean draw(SineStaff staff) {
    return draw(staff, stemDirection(), true, 255);
  }
  
  public boolean draw(SineStaff staff, int direction, boolean draw_stem, float opacity) {
    // Draw the note
    // if not out of bounds
    int index = (int) x();
    if (index >= staff.getNumPositions()) { return false; }
    
    last_position = staff.getPosition(line, index);
    
    float x = last_position.x;
    index = (int) x;
    if (index >= staff.getNumPositions()) { return false; }
    
    diameter = staff.getLineSpacing((int)x);
    if (bAboveLine) {
      last_position.y -= diameter/2;
    }
    float y = last_position.y;
    
    stroke(250, opacity);
    
    if (isFilled) { fill(250, opacity); }
    else { noFill(); }
    
    textSize(6);
    //drawTextCircle(x, y, diameter * 0.85/2, 'x');
    drawTextSpiral(x, y, diameter * 0.85/2, 'x');
    
    noStroke();
    //ellipse(x, y, diameter * 0.85, diameter * 0.85);
    
    if (!draw_stem) return true;
    
    // Draw the stem
    drawStem(x, y, direction > 0);
    
    return true;
  }   
  
  private void drawStem(float x, float y, boolean dir) {
    if (dir) {
      line(x + diameter* 0.85/2, y, x + diameter* 0.85/2, y - diameter * 2);
    } else {
      line(x - diameter* 0.85/2, y, x - diameter* 0.85/2, y + diameter * 2);
    }
  }
  
  private void drawTextCircle(float x, float y, float radius, char letter) {
    float letter_angle = 0;
    float letter_width = textWidth(letter);
    while(letter_angle < TWO_PI) {
      float letter_x = cos(letter_angle) * radius;
      float letter_y = sin(letter_angle) * radius;
      
      pushMatrix();
      translate(x+letter_x, y+letter_y);
      rotate(letter_angle + PI/2);
      text(letter, 0, 0);
      popMatrix();
      
      letter_angle += letter_width/radius;
    }
  }
  
  private void drawTextSpiral(float x, float y, float radius, char letter) {
    textSize(10);
    float r = 0;//textWidth(letter);
    float arclen = textWidth(letter);
    pushMatrix();
    translate(x, y);
    while (r <= radius*1.2) {
      r += 0.2;
      
      float theta = arclen/r;
      rotate(theta);
      text(letter, 0, r);
    }
    popMatrix();
  }
  
}
  