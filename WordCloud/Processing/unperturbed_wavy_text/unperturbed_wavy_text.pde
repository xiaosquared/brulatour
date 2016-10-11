// 10.4.16
//
// Unperturbed Wavy Text
//
// Text that floats with the waves undisturbed by perturbations
//
// 10.5.16: fading away

import java.util.*;
import de.looksgood.ani.*;

Wave w;
Rain r;
PVector g = new PVector(0, 0.1);
float water_density = 0.00006;

FloatyWavyText fwt;
PFont font;

void setup() {
  size(600, 600, P2D);
  background(30);
  
  Ani.init(this);
  w = new Wave(new PVector(-20, 350), new PVector(650, 350), 4, 200);
  
  r = new Rain(20, w);
  
  font = createFont("American Typewriter", 100);
  textFont(font);
  fwt = new FloatyWavyText("HelloWorld", 70, 100, 0);
}

void draw() {
  background(30);
  w.update();
  w.draw();
  
  r.run(true);
  
  fwt.update();
  fwt.draw();
  if (fwt.hittingWater())
    fwt.hitWater();
}

void mousePressed() {
  //w.getSelectedSpring(mouseX).perturb();
  int i = w.getSelectedSpringIndex(mouseX);
  w.springs[i].perturb();
  w.springs[i+1].perturb();
  w.springs[i-1].perturb();
}

void keyPressed() {
  //fwt = new FloatyWavyText("HelloWorld", 80, 100, 0);
}