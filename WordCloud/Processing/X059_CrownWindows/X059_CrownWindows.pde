// 11.17.17
//
// Crown windows
//
// Windows with the top part
// 

Layer l, lv;
CrownWindow cw;

void setup() {
  size(1200, 800);
  noFill();
  stroke(200);
  background(30);
  
  cw = new CrownWindow(new PVector(100, 100), new PVector(500, 700), 25);
  cw.draw();
}

void draw() {

}

void keyPressed() {
  println(key);

}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}