public class Note {
  int line;
  boolean bAboveLine;
  
  float start_x;
  float trans_x = 0;
  
  public Note(int line, boolean bAboveLine, float start_x) {
    this.line = line;
    this.start_x = start_x;
    this.bAboveLine = bAboveLine;
  }
  
  public void update() {
    trans_x++;
  }
  
  public float x() { return start_x + trans_x; }
  
  public void draw(StaffLines staff, float diameter) {
    float x = staff.staff_positions[line].x;
    float y = staff.staff_positions[line].y;
    
    if (bAboveLine) {
      y += diameter/2;
    }
    ellipse(x, y, diameter * 0.85, diameter * 0.85);
  }
}