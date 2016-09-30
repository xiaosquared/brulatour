// UPDATED CONSTRUCTOR! 9.29.16
// making waves 9.30.16

class Wave {
  Spring[] springs;
  float[] leftDeltas;
  float[] rightDeltas;
  
  float radius;
  float target_height;
  float spread = 0.48;
 
  float amplitude = 0;
  float freq_factor = 10; 
  int end;
  
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
    
    leftDeltas = new float[n];
    rightDeltas = new float[n];
  }
  
  void startWave() {
    float max_amp = random(40, 80);
    float stillness = random(3, 8);
    float start_duration = random(2, 5);
    end = (frameRate%2==0) ? 0 : springs.length-1;
    Ani.to(this, start_duration, stillness, "amplitude", max_amp, Ani.SINE_IN_OUT, "onEnd:endWave");
  }
  
  void endWave() {
    float wave_duration = random(1, 3);
    float end_duration = random(2, 5);
    Ani.to(this, end_duration, wave_duration, "amplitude", 0, Ani.SINE_IN_OUT, "onEnd:startWave");
  }
  
  void update() {
    if (amplitude != 0) {
      float theta = (float)frameCount/freq_factor;
      springs[end].pos.y = amplitude*sin(theta) + target_height;
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
    
    if (random(100+amplitude*100) < 1) { 
       springs[floor(random(springs.length))].perturb();         
    }
    
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
      stroke(100);
      fill(200);
      for (int i = 0; i < springs.length; i++) {
        ellipse(springs[i].pos.x, springs[i].pos.y, radius, radius);
      }
    }
  }
}