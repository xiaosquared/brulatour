class MultiRain {
  Rain[] rains;
  Splashing sp;
  
  MultiRain(MultiWave mw, Splashing sp, String[] words, int n) {
    this.sp = sp;
    rains = new Rain[mw.waves.length];
    for (int i = 0; i < mw.waves.length; i++) {
      Rain r = new Rain(words, n, mw.waves[i]);
      rains[i] = r;
    }
    //restart();
  }
  
  void run(boolean letters, boolean raining) {
    for (int i = 0; i < rains.length; i++) {
      rains[i].run(sp, letters, raining);
    }
  }
  
  void restart() {
    for (int i = 0; i < rains.length; i++) {
      rains[i].restart();
    }
  }
}

class Rain {
  ArrayList<RainDrop> rain;
  Wave target_wave;
  int n = 12;
  
  Rain(String[] words, int n, Wave target_wave) {
    this.target_wave = target_wave;
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
  
  void run(Splashing sp, boolean letters, boolean raining) {
    Iterator<RainDrop> it = rain.iterator();
    while(it.hasNext()) {
      RainDrop r = it.next();
      
      r.update();
      r.draw(letters);
      
      if (r.pos.y > target_wave.target_height) {
        Spring s = target_wave.getSelectedSpring((int)r.pos.x);
        r.respawn(!raining);
        s.perturbRain();
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
        r.acc.y = g.y;
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