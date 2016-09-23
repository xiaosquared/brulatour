// 9.23.16
//
// Rain into Water

import java.util.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

ArrayList<RainDrop> rain;

Wave w;

void setup() {
  size(1200, 600, P2D);
  background(30);
  fill(200);
  stroke(150);
  
  Ani.init(this);
  rain = new ArrayList<RainDrop>();
  w = new Wave(new PVector(2, 380), 2, width/4);
}

void draw() {
  background(30);
  Iterator<RainDrop> it = rain.iterator();
  while(it.hasNext()) {
    RainDrop r = it.next();
    r.run();
    if (r.isDead()) {
      r.respawn();
    }
  }
  
  w.run();
}

void mousePressed() {
  RainDrop r = new RainDrop(mouseX);
  rain.add(r);
  println(r.pos);
}