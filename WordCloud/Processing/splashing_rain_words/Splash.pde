class Splashing {
  ArrayList<Particle> droplets;
  int pps = 6;  // particles per splash
  float splash_speed = 4.5;
  
  Splashing() {
    droplets = new ArrayList<Particle>();
  }
  
  void run() {
    Iterator<Particle> it = droplets.iterator();
    while (it.hasNext()) {
      Particle p = it.next();
      p.run();
      if (p.isDead()) {
        it.remove();
      }
    }
  }
  
  void createSplash(float x, float y) {
    for (int i = 0; i < pps; i ++) {
      float radians = random(0, PI);
      PVector v = new PVector(splash_speed*cos(radians)/2 + random(-1, 1),
                              -splash_speed*sin(radians) + random(-1, 1));
      PVector p = new PVector(x + random(-5, 5), y + random(-12, 12));
      PVector a = new PVector(0, .3);
      
      char c = (char) int(random(97, 122));
      droplets.add(new SplashDrop(p, v, a, c));
    }
  } 
}