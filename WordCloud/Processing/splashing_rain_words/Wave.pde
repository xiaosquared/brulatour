class Wave {
  Spring[] springs;
  float[] leftDeltas;
  float[] rightDeltas;
  
  float target_height;
  float spread = 0.2;
  float radius;
 
  ArrayList<WavyText> texts;
  int font_size; 
 
  Wave(PVector startPos, float radius, int n, int fs) {
    target_height = startPos.y;
    this.radius = radius;

    springs = new Spring[n];
    leftDeltas = new float[n];
    rightDeltas = new float[n];
    
    for (int i = 0; i < n; i++) {
      float x = startPos.x + 2*radius*i;
      float y = startPos.y;
      springs[i] = new Spring(new PVector(x, y));
    }
    
    font_size = fs;
    texts = new ArrayList<WavyText>();
  }
  
  void initText(String[] words) {
    int selected = 0;
    while(selected < springs.length) {
      int w_index = floor(random(words.length));
      String word = words[w_index];
      WavyText w = new WavyText(word, 8, springs[selected].pos.x, target_height);
      w.spring_offset = selected;
      selected = w.assignSprings(radius * 2, springs.length);
      if (selected < springs.length)
        texts.add(w);
      selected+=2;  
    }
  }
  
  
  float getStartX() {
    return springs[0].pos.x;
  }
  
  // perturbs spring closest to x position 
  void perturb(int x) {
    Ani.to(getSelectedSpring(x).pos, 0.1, "y", random(target_height-50, target_height+50));
  }
  
  // returns spring closest to x position
  Spring getSelectedSpring(int x) {
    return springs[floor((x-getStartX()) / (radius * 2))];
  }
  
  void run(boolean letters) {
    update();
    draw(letters);
  }
  
  void update() {
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
    if (letters) {
      fill(200);
      Iterator<WavyText> it = texts.iterator();
      while (it.hasNext()) {
        WavyText wt = it.next();
        wt.draw(springs);
      }
    }
    else {  
      stroke(100);
      fill(200);
      for (int i = 0; i < springs.length; i++) {
        ellipse(springs[i].pos.x, springs[i].pos.y, radius, radius);
      }
    }
  }
}