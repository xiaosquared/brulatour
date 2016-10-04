class Rain {
  ArrayList<RainDrop> rain;
  int n = 12;
  
  Rain(String[] words, int n) {
    this.n = n;
    rain = new ArrayList<RainDrop>();
    for (int i = 0; i < n; i++) {
      int w_index = floor(random(words.length));
      String word = words[w_index];
      
      RainDrop r = new RainDrop(new PVector(random(4, width-4), -i*150),
                                new PVector(0, 0),
                                new PVector(0, 0.0), word);
      rain.add(r);                          
    }
  }
  
  void run(Wave w, Splashing sp, boolean letters, boolean raining) {
    Iterator<RainDrop> it = rain.iterator();
    while(it.hasNext()) {
      RainDrop r = it.next();
      
      r.update();
      r.draw(letters);
      
      if (r.pos.y > w.target_height) {
        Spring s = w.getSelectedSpring((int)r.pos.x);
        r.respawn(!raining);
        s.perturb();
        sp.createSplash(s.pos.x, s.pos.y);
      }
    }    
  }
  
  void restart() {
    for (int i = 0; i < n; i++) {
      RainDrop r = rain.get(i);
      if (r.pos.y < 0) {
        r.pos.y = -i*150;
        r.vel.y = 10;
        r.acc.y = 0.1;
      }
    }
  }
}

class Splashing {
  ArrayList<SplashDrop> droplets;
  int pps = 6;  // particles per splash
  float splash_speed = 4.5;
  
  Splashing() {
    droplets = new ArrayList<SplashDrop>();
  }
  
  void run(boolean letters) {
    Iterator<SplashDrop> it = droplets.iterator();
    while (it.hasNext()) {
      SplashDrop p = it.next();
      p.update();
      p.draw(letters);
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