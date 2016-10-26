// 9.23.16
//
// Rain into Water
//
// two particle systems! rain + waves that interact
// click to add raindrops

import java.util.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

ArrayList<RainDrop> rain;

Wave w;
int r = 1;

void setup() {
  size(1200, 600, P2D);
  background(30);
  fill(200);
  stroke(150);
  
  Ani.init(this);
  rain = new ArrayList<RainDrop>();
  w = new Wave(new PVector(2, 450), r, width/(2*r));
}

void draw() {
  background(30);
  Iterator<RainDrop> it = rain.iterator();
  while(it.hasNext()) {
    RainDrop r = it.next();
    r.run();
    if (r.pos.y > w.TARGET_HEIGHT - 50) {
      Spring s = w.getSelectedSpring((int)r.pos.x);
      if (r.pos.y > s.pos.y) {
        r.respawn();
        s.perturb();
      }
    }
  }
  w.run();
}

void mousePressed() {
  RainDrop r = new RainDrop(mouseX);
  rain.add(r);
  println(r.pos);
}