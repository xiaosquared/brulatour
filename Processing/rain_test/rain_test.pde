// 2.28.16
//
// Rain Test
//
// Initial test of a particle system that "rains" words about New Orleans

import java.util.*;

ArrayList<Particle> particles;
float start_y = -70;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nsugar\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane\nslavery\nReconstruction\nantibellum";
String[] words = new String[25];

PFont font;
int font_size = 8;

void setup() {
  size(800, 800, P2D);
  background(50);
  
  particles = new ArrayList<Particle>();
  
  words = split(phrase, '\n');
  font = createFont("American Typewriter", font_size);
  textFont(font, font_size);
}

void draw() {
  background(50);
  
  Iterator<Particle> it = particles.iterator();
  while(it.hasNext()) {
    Particle p = it.next();
    p.run();
    if (p.isDead()) {
      it.remove();
    }
  }
  
  int index = floor(random(25));
  Particle p = new Particle(new PVector(random(width), start_y), words[index]);
  particles.add(p);
}