class MultiWave {
  Wave[] waves;
  
  MultiWave(int n, PVector tl, PVector br, float particle_width, int sShade, int eShade) {
    waves = new Wave[n];
    
    float start_x = tl.x;
    float end_x = br.x;
    
    float start_y = tl.y;
    float total_y = br.y - tl.y;
    float spacing_y = (total_y * 0.8)/n;
    
    int subdiv = 0;
    for (int i = 1; i < n; i++) {
      subdiv += i;
    }
    float offset = 0;
    float offset_inc = (total_y * .2)/subdiv;
    
    for (int i = 0; i < n; i++) {
      float y = start_y + spacing_y*i + offset*i;
      int shade = sShade + (eShade - sShade)/n * i;
      Wave w = new Wave(new PVector(start_x, y), new PVector (end_x + i*20, y), particle_width, shade);
      offset+=offset_inc;
      waves[i] = w;
      
      w.startWaving();
    }
  }
  
  void initText(String[] words, float s_font_size, float e_font_size) {
    for (int i = 0; i < waves.length; i++) {
      float fs = (e_font_size - s_font_size)/waves.length*i + s_font_size;
      println(fs);
      waves[i].initText(words, fs, 0, waves[i].springs.length);
    }
  }
  
  void update() {
    for (int i = 0; i < waves.length; i++) {
      waves[i].update();
    }
  }
  
  void draw(boolean letters) {
    for (int i = 0; i < waves.length; i++) {
      waves[i].draw(letters);
    }
  }  
}