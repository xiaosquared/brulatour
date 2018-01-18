// 11.28.17
//
// New version of Houses
//
// 'b' to toggle black and white mode
// 'space' to reset
// 'enter' to start/stop
//
// Types: 
//    - normal rectangular windows
//    - arch windows    
//    - railing + windows
// Also 2 types of roofs: 
//    - set angle (radians)
//    - triangle roof
//
//
// Edit 12.10.17
//
// houses fade away word by word randomly  
// NOTE: will need to update the code for Roof because I changed the class definition
// in a later sketch
//
// Tried moving all the houses with an Ani tween, but it flickers... Maybe it's drawing too much?
// 

import java.util.Iterator; 
import de.looksgood.ani.*;

boolean bw_mode = true;

Block block;
float three_width = 250;
float four_width = 300;
float story_height = 200;
float layer_thickness = 4;
int wall_hue = 50;
int railing_hue = 100;
int window_hue = 280;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCarondolet Canal\nsugar\ntobacco\ncotton\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\ncypress\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nDowntown\nhurricane\nslavery\nReconstruction\nantibellum";
PFont font;
int default_font_size = 20;
WordManager wm;

boolean go = false;
Iterator<Brick> bricks;
int words_per_frame = 10;

void setup() {
  size(1280, 800, P2D);
  smooth(4);
  textAlign(LEFT, TOP);
  colorMode(HSB, 360, 100, 100);

  font = createFont("American Typewriter", 60);
  textFont(font, default_font_size);

  wm = new WordManager();
  wm.addAllWords(phrase);

  block = new Block(80, height-100);

  House house = new House(block.getNextX(), block.getBaseY(), three_width, 3, layer_thickness);
  house.addArchStory(wall_hue, window_hue);
  house.addBalconyStory(wall_hue, railing_hue, window_hue);
  house.addTriangularRoof(true, railing_hue);
  block.addHouse(house);

  house = new House(block.getNextX(), block.getBaseY(), four_width, 4, layer_thickness);
  house.addStory(wall_hue, window_hue);
  house.addBalconyStory(wall_hue, railing_hue, window_hue);
  house.addBalconyStory(wall_hue, railing_hue, window_hue);
  house.addRoof(false, radians(16), railing_hue);
  block.addHouse(house);

  house = new House(block.getNextX(), block.getBaseY(), three_width*1.25, 3, layer_thickness);
  house.addArchStory(wall_hue, window_hue);
  house.addBalconyStory(wall_hue, railing_hue, window_hue);
  house.addRoof(false, radians(16), railing_hue);
  block.addHouse(house);

  house = new House(block.getNextX(), block.getBaseY(), three_width, 3, layer_thickness);
  house.addArchStory(wall_hue, window_hue);
  house.addStory(wall_hue, window_hue);
  house.addTriangularRoof(false, railing_hue);
  block.addHouse(house);

  block.makeSidewalk(50, railing_hue);

  background(0);
  block.fillAll();
  block.draw(false, false, true);
  
  Ani.init(this);
}

void draw() {
  background(0);
  block.draw();
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}

void keyPressed() {
  switch(key) {
  case 32:
    block.reset();
    background(30);
    //block.draw(true, true, true);
    break;

  case 10:
    go = !go;
    println(go);
    break;
    
  case 'b':
    bw_mode = ! bw_mode;
    //background(30);
    //block.draw(false, true, true);
    break;

  case 't':
    Ani.to(block.trans, 10, "y", -500, Ani.SINE_IN);
    break;
  case 'a':
    //println("move left");
    //background(30);
    //house.translateX(-5);
    //house.draw(false, false, true);
    break;
  case 's':
    //println("move right");
    //background(30);
    //house.translateX(5);
    //house.draw(false, false, true);
    break;
  }
}