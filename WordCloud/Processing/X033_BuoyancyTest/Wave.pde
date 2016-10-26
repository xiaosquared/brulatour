class Wave {
  Spring[] springs;
  float[] leftDeltas;
  float[] rightDeltas;
  
  float target_height;
  float spread = 0.2;
  float radius;
 
  Wave(PVector startPos, float radius, int n) {
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
    return springs[getSelectedSpringIndex(x)];
  }
  
  // Gets the index of spring closest to x position
  int getSelectedSpringIndex(int x) {
    return floor((x-getStartX()) / (radius * 2));
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
  
  void draw() {
    stroke(100);
    fill(200);
    for (int i = 0; i < springs.length; i++) {
      ellipse(springs[i].pos.x, springs[i].pos.y, radius, radius);
    }
  }
  
  void run() {
    update();
    draw();
  }
}