class ParticleManager {
  Wave w;
  Rain r;
  Splashing sp;
  
  boolean renderLetters = true;
  
  ParticleManager() {
    w = new Wave(new PVector(-2, 450), 2, width/4 + 16, 8);
    r = new Rain(words);
    sp = new Splashing();
  }
  
  void update() {
    r.run(w, sp, renderLetters);
    w.run(renderLetters);
    sp.run(renderLetters);
  }
}