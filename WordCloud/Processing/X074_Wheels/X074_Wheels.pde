// 12.27.17
//
// Wheels
//
// Experimenting with turning wheels 
// Eventually to make vehicles of words

Wheel w;

void setup() {
  size(600, 600);
  background(0);
  
  w = new Wheel(100);
}

void draw() {
  background(0);
  w.turn();
  w.draw();
}



void keyPressed() {
  background(0);
}