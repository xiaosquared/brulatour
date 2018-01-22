public class Note {
  int line;
  boolean bAboveLine;
  
  float start_x;
  float trans_x = 0;
  PVector last_position = new PVector(0, 0);
  float diameter = 0;
  
  NoteName note;  
  
  public Note(NoteName note, float start_x) {
    this.note = note;
    this.start_x = start_x;
    
    this.line = whichLine();
    this.bAboveLine = isOnLine();
  }
  
  public PVector position() { return last_position; }
  
  public void update() {
    trans_x++;
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
  
  public void draw(SineStaff staff) {
    draw(staff, stemDirection(), true);
  }
  
  public void draw(SineStaff staff, int direction, boolean draw_stem) {
    // Draw the note
    // if not out of bounds
    int index = (int) x();
    if (index >= staff.getNumPositions())
      return;
    
    last_position = staff.getPosition(line, index);
    if (bAboveLine) {
      last_position.y -= diameter/2;
    }
    float x = last_position.x;
    float y = last_position.y;
    
    diameter = staff.getLineSpacing((int)x);
    
    stroke(100); strokeWeight(2); noFill();
    ellipse(x, y, diameter * 0.85, diameter * 0.85);
    
    if (!draw_stem) return;
    
    // Draw the stem
    if (direction > 0) {
      line(x + diameter* 0.85/2, y, x + diameter* 0.85/2, y - diameter * 2);
    } else {
      line(x - diameter* 0.85/2, y, x - diameter* 0.85/2, y + diameter * 2);
    }
  }   
}
  