class SpringWater {
  Spring[] springs;
  float[] leftDeltas;
  float[] rightDeltas;
  float SPREAD = 0.2;
  boolean bUpdate = true;  
  int selected = -1;
  
  SpringWater(PVector startPos, int radius, int n) {
    springs = new Spring[n];
    leftDeltas = new float[n];
    rightDeltas = new float[n];
    for (int i = 0; i < n; i++) {
      float x = startPos.x + 2 * radius * i;
      float y = startPos.y;
      Spring s = new Spring(new PVector(x, y), radius);
      springs[i] = s;
    }
  }
  
  void update() {
    // first update each spring
    for (int i = 0; i < springs.length; i++)
      springs[i].update();
      
    // then do some passes where springs pull on their neighbors
    for (int j = 0; j < 8; j++) {
      for (int i = 0; i < springs.length; i++) {
        if (i > 0) {
          leftDeltas[i] = SPREAD * (springs[i].getSpringHeight() - springs[i-1].getSpringHeight());
          springs[i-1].vel.y += leftDeltas[i];
        }
        if (i < springs.length - 1) {
          rightDeltas[i] = SPREAD * (springs[i].getSpringHeight() - springs[i+1].getSpringHeight());
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
  
  void draw() {
    for (int i = 0; i < springs.length; i++) {
      springs[i].draw();
    }
  }
  
  void mousePressed() {
    for (int i = 0; i < springs.length; i++) {
      if (springs[i].insideParticle(mouseX, mouseY)) {
        selected = i;
      }
    }
  }
  
  void mouseDragged() {
    if (selected >= 0) {
      springs[selected].pos.y = mouseY;
    }
  }
  
  void mouseReleased() {
    selected = -1;
  }
}