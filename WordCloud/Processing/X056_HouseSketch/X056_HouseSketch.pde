// 11.13.17
//
// House Sketch
//
// Made a wall. When you click, it makes holes. This will be for windows

Wall wall;

float default_font_size = 15;
float layer_height = 20;

void setup() {
  size(1200, 800);
  background(30);
  
  wall = new Wall(100, 100, 800, 600, 15);
  wall.draw();
}

void draw() {
  background(30);
  wall.draw();
}

void mousePressed() {
  wall.addHole(new Rectangle(mouseX, mouseY, 100, 200));
}