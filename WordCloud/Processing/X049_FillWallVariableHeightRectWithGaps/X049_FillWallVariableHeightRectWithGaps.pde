// 11.10.17
//
// Now rectangles can be taller than one bar
//
// press space bar to reset wall to diff configuration

Wall wall = new Wall(100, 100, 1000, 600, 15);

void setup() {
  size(1200, 800);
  noStroke();
  
  fillWall();
}

void draw() {
  
}

void fillWall() {
  while(!wall.isFilled()) {
    background(30);
    wall.addBrick(50, 120);
    //delay(5);
  }
  wall.drawBars();
  wall.drawBricks();
}

void keyPressed() {
    wall.reset();
    fillWall();
    //background(30);
    //wall.addBrick(20, 200);
    //wall.drawBricks();
    //wall.drawBars();
}