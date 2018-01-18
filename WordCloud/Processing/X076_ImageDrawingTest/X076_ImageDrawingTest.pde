// 12.29.17
//
// Image Drawing Test
//
// Translating a block of houses as image
//
// w - move houses up
// s - move houses down
// a - scale houses to 0.5
// d - scale houses to 1

import de.looksgood.ani.*;

PGraphics pg;
PImage houses;

float y;
float scale = 1;

void setup() {
  size(1280, 800, P2D);
  smooth(4);
  
  Ani.init(this);
  houses = loadImage("houses.png");
  background(0);
  pg = createGraphics(1280, 600);
}

void draw() {
  drawOffscreen();
  image(pg, 0, y, pg.width * scale, pg.height * scale);
}

void drawOffscreen() {
  pg.beginDraw();
  pg.background(0);
  pg.image(houses, 0, 0);
  pg.endDraw();
}

void keyPressed() {
  if (key == 's')
    Ani.to(this, 3, "y", 250);
  else if (key == 'w')
    Ani.to(this, 3, "y", 0);
  else if (key == 'a')
    Ani.to(this, 3, "scale", 0.5);
  else if (key == 'd')
    Ani.to(this, 3, "scale", 1);  
}