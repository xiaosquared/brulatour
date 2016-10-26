// 9.28.16
//
// Box2D test
//
// Dropping a bunch of text!
// Physics engine is a good way to make a word cloud!

import fisica.*;
import java.util.*;

FWorld world;
ArrayList<WordBox> boxes;

WordSet ws;
PFont font;
int default_font_size = 50;

void setup() {
  size(1200, 600, P2D);
  background(30);
  frameRate(30);
  
  stroke(200);
  fill(100);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  
  ws = new WordSet(default_font_size);  
  font = createFont("American Typewriter", 60);
  textFont(font, default_font_size); 
  
  Fisica.init(this);
  boxes = new ArrayList<WordBox>();
  
  world = new FWorld();
  world.setEdges();
  world.setGravity(0, 100);
  world.setEdgesFriction(100);
}

void draw() {
  background(30);
  
  world.step();
  Iterator<WordBox> it = boxes.iterator();
  while(it.hasNext()) {
    WordBox b = it.next();
    b.draw();
  }
}

void mousePressed() {
  int index = ws.getRandomWordIndex();
  float word_height = random(20, 50);
  float word_width = ws.getWidthFromHeight(index, word_height);
  
  FBox myBox = new FBox(word_width, word_height);
  myBox.setPosition(mouseX, mouseY);
  myBox.setDensity(1);
  myBox.setFriction(0.5);
  world.add(myBox);
  
  boxes.add(new WordBox(myBox, ws.getWord(index), word_height));
}