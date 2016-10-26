// UPDATED CONSTRUCTOR! 9.29.16

class Wave {
  Spring[] springs;
  float radius;
  float target_height;
  
  Wave(PVector startPos, PVector endPos, float particle_width) {
    this.radius = particle_width/2;
    target_height = startPos.y;
    
    int n = (int) ((endPos.x - startPos.x)/particle_width);
    springs = new Spring[n];
    for (int i = 0; i < n; i++) {
      float x = startPos.x + particle_width*i;
      float y = startPos.y;
      springs[i] = new Spring(new PVector(x, y));
    }
    
    makeSine(0);
  }
  
  void update() {
    float theta = ((float)frameCount/2) % TAU;
    makeSine(theta);
  }
  
  void makeSine(float theta) {
    for (int i = 0; i < springs.length; i++) {
      springs[i].pos.y = target_height + 4*sin(springs[i].pos.x/16 - theta);
    }
  }
  
  void draw(boolean letters) {
    if (letters) {
      println("draw words");
    } else {
      noStroke();
      fill(200);
      for (int i = 0; i < springs.length; i++) {
        ellipse(springs[i].pos.x, springs[i].pos.y, radius, radius);
      }
    }
  }
}