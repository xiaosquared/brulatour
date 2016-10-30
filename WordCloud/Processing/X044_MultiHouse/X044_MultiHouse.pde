// 10.26.16
//
// Multi House
//
// Draws several houses from JSON files
// Animation test... but it's very slow because we are drawing a lot
// TRY: drawing each house onto an image, doing it only once at the beginning. Then it should be faster...

import java.util.*;
import de.looksgood.ani.*;

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
  Ani.init(this);
}

void draw() {
  background(50);
  block.draw();
}

void mousePressed() {
  println(mouseX + ", " + mouseY); 
}

void keyPressed() {
  if (keyCode == 37) {
    Ani.to(this.block.origin, 3, "x", 100);    
  } else if (keyCode == 39) {
    Ani.to(this.block.origin, 3, "x", -100);    
  }
}