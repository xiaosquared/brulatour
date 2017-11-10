// 11.10.17
//
// Similar to what FillWidth did but with better abstraction
//

//color c = color(200, 150, 150, 100);

Wall wall = new Wall(100, 100, 1000, 400, 25);

void setup() {
  size(1200, 800);
  noStroke();
}

void draw() {
  
  
  //while(!wall.isFilled()) {
  //  wall.addBrick(20, 200);
  //  wall.drawBars();
  //  wall.drawBricks();
  //}
  
}

void keyPressed() {
  background(30);
  wall.addBrick(20, 200);
  wall.drawBars();
  wall.drawBricks();
}