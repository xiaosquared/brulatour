// 10.26.16
//
// Multi House
//
// Draws several houses from JSON files
// 

import java.util.*;

WordSet ws;
PFont font;
int defaultFontSize = 20;

Block block;

void setup() {
  size(1500, 800);
  stroke(200);
  textAlign(LEFT, TOP); 
  
  ws = new WordSet(defaultFontSize);
  font = createFont("American Typewriter", 60);
  textFont(font, defaultFontSize);
 
  block = new Block();
}

void draw() {
  background(50);
  block.draw();
}

void mousePressed() {
  println(mouseX + ", " + mouseY); 
}

void keyPressed() {
    
}