public class Note {
  int line;
  boolean bAboveLine;
  
  float start_x;
  float trans_x = 0;
  
  NoteName note;  
  
  public Note(NoteName note, float start_x) {
    this.note = note;
    this.start_x = start_x;
    
    this.line = whichLine();
    this.bAboveLine = isOnLine();
  }
  
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
  
  public void draw(StaffLines staff, float diameter) {
    // Draw the note
    float x = staff.staff_positions[line].x;
    float y = staff.staff_positions[line].y;
    
    stroke(100); strokeWeight(2); noFill();
    if (bAboveLine)
      y += diameter/2;  
    ellipse(x, y, diameter * 0.85, diameter * 0.85);
    
    // Draw the stem
    if (stemDirection() > 0) {
      line(x + diameter* 0.85/2, y, x + diameter* 0.85/2, y - diameter * 2);
    } else {
      line(x - diameter* 0.85/2, y, x - diameter* 0.85/2, y + diameter * 2);
    }
    
  }   
}
  