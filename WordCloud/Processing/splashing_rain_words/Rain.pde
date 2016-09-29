class Rain {
  ArrayList<RainDrop> rain;
  int n = 12;
  
  Rain(String[] words) {
    rain = new ArrayList<RainDrop>();
    for (int i = 0; i < n; i++) {
      int w_index = floor(random(words.length));
      String word = words[w_index];
      
      RainDrop r = new RainDrop(new PVector(random(4, width-4), -i*150),
                                new PVector(0, 10),
                                new PVector(0, 0.1), word);
      rain.add(r);                          
    }
  }
  
  void run(Wave w, Splashing sp, boolean letters) {
    Iterator<RainDrop> it = rain.iterator();
    while(it.hasNext()) {
      RainDrop r = it.next();
      
      r.update();
      r.draw(letters);
      
      if (r.pos.y > w.target_height) {
        Spring s = w.getSelectedSpring((int)r.pos.x);
        r.respawn();
        s.perturb();
        
        sp.createSplash(s.pos.x, s.pos.y);
      }
    }    
  }
}