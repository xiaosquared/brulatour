// 1.18.18
//
// Staff Lines with Notes
//
// Press any key to add a new note. Notes are from E to high G on the treble clef
//

StaffLines staff;

void setup() {
  size(1200, 800, P2D);

  staff = new StaffLines();
  background(0);
  staff.draw();
  
  staff.addNote(1, false);
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
  int line = floor(random(5));
  boolean bAboveLine = floor(random(2))%2 == 0; 
  staff.addNote(line, bAboveLine); 
}