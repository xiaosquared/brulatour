// 9.27.16
//
// Splashing Rain
//
// 3 particle systems that interact: wave, rain, splash
// refactored code for managing particles

import java.util.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

ParticleManager pm;

void setup() {
  size(1200, 600, P2D);
  background(30);
 
  Ani.init(this);
  
  pm = new ParticleManager();
}

void draw() {
  background(30);
  pm.update();
}

void mousePressed() {
  println(mouseX, mouseY);
  pm.w.perturb(mouseX);
  pm.createSplash(mouseX, 450);
}