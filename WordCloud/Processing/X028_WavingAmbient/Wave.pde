class Wave {
  Spring[] springs;
  float[] leftDeltas;
  float[] rightDeltas;
  
  float TARGET_HEIGHT;
  float SPREAD = 0.2;
  
  boolean bUpdate = true;  
  int selected = -1;
  
  boolean bDrawLine = true;
 
  String t = "The rest of my days I'm going to spend on the sea. And when I die, I'm going to die on the sea. You know what I shall die of? I shall die of eating an unwashed grape. One day out on the ocean I will die----with my hand in the hand of some nice looking shi";
  WavyText wt;

  Wave(PVector startPos, int radius, int n) {
    springs = new Spring[n];
    leftDeltas = new float[n];
    rightDeltas = new float[n];
    
    TARGET_HEIGHT = startPos.y;
    
    for (int i = 0; i < n; i++) {
      float x = startPos.x + 2 * radius * i;
      float y = startPos.y;
      
      Spring s = new Spring(new PVector(x, y), radius);
      springs[i] = s;
    }
    
    wt = new WavyText(t, 10, 6, 0);
    wt.assignSprings(springs);
  }
  
  float getParticleRadius() {
    return springs[0].radius;
  }
  
  float getStartX() {
    return springs[0].pos.x;
  }
   
  Spring getSelectedSpring(int x) {
    return springs[floor((x - getStartX()) / (getParticleRadius() * 2))];
  }
  
  void perturb(int x) {
    Ani.to(getSelectedSpring(x).pos, 0.1, "y", random(TARGET_HEIGHT-50, TARGET_HEIGHT+50));
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
      springs[i].draw(bDrawLine);
    }
    
    wt.draw(springs);
  }
  
  void mousePressed() {
    for (int i = 0; i < springs.length; i++) {
      if (springs[i].pullingParticle(mouseX, mouseY)) {
        //selected = i;
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