// 11.14.17
//
// Slice Ellipse
//
// Turning a curved shape into layers.. in order to make holes for the walls
// Do it for both vertical and horizontal slices!
//


void setup() {
  size(1200, 600);
  ellipseMode(CENTER);
  
  noFill();
  stroke(200);
}

void draw() {
  background(30);
  
  ellipse(300, 300, 200, 200);
  line(600, 0, 600, 600);
  ellipse(900, 300, 200, 200);
}


void mousePressed() {
  println(mouseX + ", " + mouseY);
}