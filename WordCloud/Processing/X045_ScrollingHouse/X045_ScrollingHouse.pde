// 10.29.16
//
// Scrolling House
//
// A block of houses that infinitely scrolls across the screen  

import java.util.*;

ScrollingBlock block;

void setup() {
  size(1500, 800);
  
  block = new ScrollingBlock();
}

void draw() {
  background(50);
  block.update();
  block.draw();
}

void mousePressed() {
  println(mouseX + ", " + mouseY); 
}

void keyPressed() {
  if (keyCode == 37) {
    block.scrollLeft(5);
  } else if (keyCode == 39) {
    block.scrollRight(5);
  }
}