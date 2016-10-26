class Wave {
  Spring[] springs;
  float[] leftDeltas;
  float[] rightDeltas;
  
  float radius;
  float target_height;
  float spread = 0.48;
  
  float amplitude = 0;
  float freq_factor = 10;
  int end;  // which end ambient traveling waves start from
  
  ArrayList<WavyText> texts;
  float font_size = 0;
  int shade = 200;
  
  Wave(PVector startPos, PVector endPos, float particle_width, int shade) {
    this.shade = shade;
    this.radius = particle_width/2;
    target_height = startPos.y;
    
    int n = (int) ((endPos.x - startPos.x) / particle_width);
    springs = new Spring[n];
    for (int i = 0; i < n; i++) {
      float x = startPos.x + particle_width * i;
      float y = startPos.y;
      springs[i] = new Spring(new PVector(x, y));
    }
    
    leftDeltas = new float[n];
    rightDeltas = new float[n];
  }
  
  void initText(String[] words, float fs, int start_spring, int end_spring) {
    font_size = fs;
    textSize(font_size);
    texts = new ArrayList<WavyText>();
    
    int selected_spring = start_spring;
    while(selected_spring < end_spring) {
      int w_index = floor(random(words.length));
      String word= words[w_index];
      WavyText wt = new WavyText(word, fs,
                        springs[selected_spring].pos.x, target_height);
      float word_width = textWidth(word);
      selected_spring += (int) (word_width/(radius*2));
      if (selected_spring < springs.length)
        texts.add(wt);
      selected_spring +=2;
    }
  }
  
  // returns spring closest to x position
  Spring getSelectedSpring(int x) {
    return springs[floor((x-springs[0].pos.x) / (radius * 2))];
  }
  
  void startWaving() {
    float max_amp = random(40, 80);
    float stillness = random(3, 8);
    float ramp_up = random(2, 5);
    end = (frameRate%2 ==0) ? 0 : springs.length - 1; // which side of the wave to start on?
    Ani.to(this, ramp_up, stillness, "amplitude", max_amp, Ani.SINE_IN_OUT, "onEnd:endWaving");
  }
  
  void endWaving() {
    float wave_duration = random(1, 3);
    float ramp_down = random(2, 5);
    Ani.to(this, ramp_down, wave_duration, "amplitude", 0, Ani.SINE_IN_OUT, "onEnd:startWaving");
  }
  
  void update() {
    // deal with traveling wave
    if (amplitude != 0) {
      float theta = (float) frameCount/freq_factor;
      springs[end].pos.y = amplitude*sin(theta) + target_height;
    }
    
    // perturbation
    if (random(100+amplitude*100) < 1) { 
       springs[floor(random(springs.length))].perturb();         
    }
    
    // first update each spring
    for (int i = 0; i < springs.length; i++)
      springs[i].update();
    
    // then do some passes where springs pull on their neighbors
    for (int j = 0; j < 8; j++) {
      for (int i = 0; i < springs.length; i++) {
        if (i > 0) {
          leftDeltas[i] = spread * (springs[i].getSpringHeight() - springs[i-1].getSpringHeight());
          springs[i-1].vel.y += leftDeltas[i];
        }
        if (i < springs.length - 1) {
          rightDeltas[i] = spread * (springs[i].getSpringHeight() - springs[i+1].getSpringHeight());
          springs[i+1].vel.y += rightDeltas[i];
        }
      }
      for (int i = 0; i < springs.length; i++) {
        if (i > 0) 
          springs[i-1].pos.y += leftDeltas[i];
        if (i < springs.length - 1)
          springs[i+1].pos.y += rightDeltas[i];
      }
    }
  }
  
  void draw(boolean letters) {
    fill(shade);  
    if (letters) {
      if (texts == null) {
        draw(false);
        return;
      }
      
      Iterator<WavyText> it = texts.iterator();
      while(it.hasNext()) {
        WavyText wt = it.next();
        wt.draw(springs, radius*2);
      }
    } else {
      stroke(shade);
      for (int i = 0; i < springs.length; i++) {
        ellipse(springs[i].pos.x, springs[i].pos.y, radius, radius);
      }
    }
  }
}