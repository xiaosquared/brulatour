class ParticleManager {
  Wave w;  
  ArrayList<Particle> rain;
  int nrain = 10; // particles of rain
  ArrayList<Particle> splashes;
  int pps = 6;  // particles per splash
  float splash_speed = 4.5;
  
  ParticleManager() {
    rain = new ArrayList<Particle>();
    for (int i = 0; i < nrain; i++) {
      Particle r = new RainDrop(new PVector(random(4, width-4), -i*200),
                                new PVector(0, 10),
                                new PVector(0, 0.5));
      rain.add(r);
    }
    
    w = new Wave(new PVector(2, 450), 2, width/4);
    
    splashes = new ArrayList<Particle>();
  }
  
  void update() {
    
    // rain
    Iterator<Particle> it = rain.iterator();
    while(it.hasNext()) {
      Particle r = it.next();
      r.run();
      if (r.pos.y > w.target_height - 50) {
        Spring s = w.getSelectedSpring((int)r.pos.x);
        r.respawn();
        s.perturb();
        createSplash((int)s.pos.x, (int)s.pos.y);
      }
    }
    
    // wave
    w.update();
    w.draw();
    
    // splashes
    it = splashes.iterator();
    while(it.hasNext()) {
      Particle p = it.next();
      p.run();
      if (p.isDead()) {
        it.remove();
      }
    }
  }
  
  void createSplash(int x, int y) {
    for (int i = 0; i < pps; i ++) {
      float radians = random(0, PI);
      PVector v = new PVector(splash_speed*cos(radians)/2 + random(-1, 1),
                              -splash_speed*sin(radians) + random(-1, 1));
      PVector p = new PVector(x + random(-5, 5), y + random(-12, 12));
      PVector a = new PVector(0, .3);
      splashes.add(new SplashDrop(p, v, a));
    }
  }
}