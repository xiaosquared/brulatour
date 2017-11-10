// 11.10.17
//
// Now rectangles can be taller than one bar
//

Wall wall = new Wall(100, 100, 1000, 600, 15);

void setup() {
  size(1200, 800);
  noStroke();
}

void draw() {
  
  if(!wall.isFilled()) {
    background(30);
    wall.addBrick(50, 120);
    wall.drawBars();
    wall.drawBricks();
    delay(5);
  }
  
}

void keyPressed() {
    //background(30);
    //wall.addBrick(20, 200);
    //wall.drawBricks();
    //wall.drawBars();
}