// 1.18.18
//
// Staff Lines with Notes
//
// Press any key to add a new note. Notes are from E to high G on the treble clef
// Edited 1.21.18:
// 
// Added Enum for NoteType for which note it is
//

StaffLines staff;
boolean DRAW_STEM = true;

void setup() {
  size(1200, 800, P2D);

  staff = new StaffLines();
  background(0);
  staff.draw();
  
  staff.addRandomNote();
}

void draw() {
  background(0);
  staff.update();
  staff.draw();
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}

void keyPressed() {
  staff.addRandomNote(); 
}