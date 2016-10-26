class Rain {
  ArrayList<RainDrop> rain;
  Wave target_wave;
  int n = 12;
  
  Rain(int n, Wave target_wave) {
    this.target_wave = target_wave;
    this.n = n;
    rain = new ArrayList<RainDrop>();
    for (int i = 0; i < n; i++) {
      RainDrop r = new RainDrop(new PVector(random(4, width-4), -i*150),
                                new PVector(0, 0),
                                new PVector(0, 0.0));
      rain.add(r);                          
    }
    restart();
  }
  
  void run(boolean raining) {
    Iterator<RainDrop> it = rain.iterator();
    while(it.hasNext()) {
      RainDrop r = it.next();
      
      r.update();
      r.draw();
      
      if (r.pos.y > target_wave.target_height) {
        Spring s = target_wave.getSelectedSpring((int)r.pos.x);
        r.respawn(!raining);
        s.perturb();
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