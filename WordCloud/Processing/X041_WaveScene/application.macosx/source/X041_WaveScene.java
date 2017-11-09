import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import de.looksgood.ani.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class X041_WaveScene extends PApplet {

// 10.3.16
//
// Wave Scene
//
// Combined system of wave, rain, splash made out of words, and big words falling into water
//
// 10.4.16: smoothed out FloatyWavyText that were jittery during rain





String phrase = "Vieux carr\u00e9\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane";
String[] words = new String[20];
int font_size = 100;
PFont font;

PVector g = new PVector(0, 0.1f);
MultiWave mw;
MultiRain r;
Splashing sp;

FloatyWavyText fwt;

boolean renderLetters = true;
boolean isRaining = false;

int rainDuration = 2000;
int lastRainTime = 0;

public void setup() {
  
  background(30);
  
  initWords();
  Ani.init(this);
  mw = new MultiWave(5, new PVector(-20, height-200), new PVector(width+200, height-20), 4, 220, 50);
  mw.initText(words, 12, 28);
  
  sp = new Splashing();
  r = new MultiRain(mw, sp, words, 12);
  lastRainTime = millis();
  
  initFallingWord();
}

public void draw() {
  background(30);
  
  if (fwt != null) {
    if (fwt.opacity == 0)
      initFallingWord();
    
    fwt.update();
    fwt.draw();
    
    if (fwt.hittingWater())
      fwt.hitWater();
  }
  
  mw.update();
  mw.draw(renderLetters);
  sp.run(true); 
  r.run(true, isRaining);
  
  int current_time = millis();
  if (current_time - lastRainTime > rainDuration) {
    isRaining = !isRaining;
    lastRainTime = current_time;
    if (isRaining) {
      r.restart();
    }
    rainDuration = PApplet.parseInt(random(10, 20) * 1000); 
  }
}

public void initWords() {
  words = split(phrase, '\n');
  font = createFont("American Typewriter", font_size);
  textFont(font, font_size);  
}

public void initFallingWord() {
  fwt = new FloatyWavyText(words[(floor(random(words.length)))], random(70, 90), random(0, width*.66f), -20, mw.waves[0]);
}

public void mousePressed() {
  println(mouseX, mouseY);
}

public void keyPressed() {
  switch(key) {
    case ' ':
      renderLetters = !renderLetters;
      break;
    case 'r':
      isRaining = !isRaining;
      lastRainTime = millis();
      if (isRaining)
        r.restart();
      break;
    case 'p':
      mw.waves[0].perturbRegion(100, 150, 20, sp);
      break;
  }
}
class FloatyWavyText extends WavyText {
  boolean inWater = false;
  PVector acc;
  float text_width;
  
  Wave target_wave;
  float[] prev_heights;
  float lifespan = 8;
  float opacity = 1;  // 0 is transparent;
  float water_density = 0.00007f;
  
  FloatyWavyText(String t, float fs, float x, float y, Wave target_wave) {
    super(t, fs, x, y);
    acc = g.copy();
    vel = new PVector(0, 5);
    
    textSize(fs);
    text_width = textWidth(t);
    this.target_wave = target_wave;
    if (text_width + start_pos.x > width)
      start_pos.x = width - text_width - random(text_width);
    
    
    prev_heights = new float[len];
    for (int i = 0; i < len; i++) {
      prev_heights[i] = 0;
    }
  }
  
  public boolean hittingWater() {
    return start_pos.y >= target_wave.target_height && !inWater;
  }
  
  public void hitWater() {
    // effect on word
    inWater = true;
    vel.x = random(-1, 1);
    Ani.to(this, lifespan, 1.5f, "opacity", 0, Ani.QUAD_IN_OUT);
   
    // effect on wave
    int left = target_wave.getSelectedSpringIndex((int)start_pos.x);
    int right = target_wave.getSelectedSpringIndex((int) (start_pos.x + text_width));
    target_wave.perturbRegion(left, right, start_pos.y + font_size/4, sp);
  }
   
  public void reset() {
    opacity = 1;
    inWater = false;
    lifespan = random(5, 10);
    start_pos.y = -200;
    vel.y = 5;
    acc = g.copy();
  }
   
  public void update() {
    PVector pos = start_pos.copy();
    
    if (inWater) {
      // Buoyancy force
      float submerged = (pos.y - target_wave.target_height + font_size/2) * text_width;
      float buoy = - submerged * water_density * g.y;
      
      // Drag
      float drag = 0.06f * vel.y * vel.y;
      if (vel.y > 0)
        drag = - drag;
      
      // total force
      acc.y = g.y + drag + buoy;
    }
    vel.add(acc);
    pos.add(vel);
    
    start_pos = pos;
  }
  
  public void draw() {
    fill(200);
    textSize(font_size);
    if (inWater) {
      drawWavyText(target_wave.springs, target_wave.radius *2);
    }
    else 
      text(text, start_pos.x, start_pos.y);
  }
  
  public void drawWavyText(Spring[] springs, float particle_width) {
    textSize(font_size);
    fill(200, 255*opacity);
    
    float caret_x = 0;
    int l_spring, r_spring, c_spring;
    
    for (int i = 0; i < len; i++) {
      char next_letter = text.charAt(i);
      float x = start_pos.x - springs[0].pos.x + caret_x;
      float letter_width = textWidth(next_letter);
      
      // get springs corresponding to Left, Right, and Center ofletter
      l_spring = (int) (x / (particle_width));
      r_spring = (int) ((x + letter_width) / (particle_width));
      c_spring = (int) ((l_spring + r_spring)/2);
      
      if (l_spring < 0 || r_spring >= springs.length) {
        vel.x = -vel.x;
        return;
      }
      
      // take the average of 3 springs
      float avg_spring_height = (springs[l_spring].getHeightDiff() +
                                springs[r_spring].getHeightDiff() +
                                springs[c_spring].getHeightDiff())/3;
      
      // then average it with previous 
      float new_height = 0.5f * avg_spring_height + 0.5f * prev_heights[i];
      prev_heights[i] = new_height;
      
      float y = start_pos.y + new_height;
      
      text(next_letter, x + springs[0].pos.x, y);
      caret_x += letter_width;
    }
  }
}
class MultiWave {
  Wave[] waves;
  
  MultiWave(int n, PVector tl, PVector br, float particle_width, int sShade, int eShade) {
    waves = new Wave[n];
    
    float start_x = tl.x;
    float end_x = br.x;
    
    float start_y = tl.y;
    float total_y = br.y - tl.y;
    float spacing_y = (total_y * 0.8f)/n;
    
    int subdiv = 0;
    for (int i = 1; i < n; i++) {
      subdiv += i;
    }
    float offset = 0;
    float offset_inc = (total_y * .2f)/subdiv;
    
    for (int i = 0; i < n; i++) {
      float y = start_y + spacing_y*i + offset*i;
      int shade = sShade + (eShade - sShade)/n * i;
      Wave w = new Wave(new PVector(start_x, y), new PVector (end_x + i*20, y), particle_width, shade);
      offset+=offset_inc;
      waves[i] = w;
      
      w.startWaving();
    }
  }
  
  public void initText(String[] words, float small_font_size, float large_font_size) {
    for (int i = 0; i < waves.length; i++) {
      float fs = (large_font_size - small_font_size)/waves.length*i + small_font_size;
      waves[i].initText(words, fs, 0, waves[i].springs.length);
    }
  }
  
  public void update() {
    for (int i = 0; i < waves.length; i++) {
      waves[i].update();
    }
  }
  
  public void draw(boolean letters) {
    for (int i = 0; i < waves.length; i++) {
      waves[i].draw(letters);
    }
  }  
}
class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  
  Particle(PVector pos) {
    this.pos = pos;
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
  }
  
  Particle (PVector pos, PVector vel) {
    this.pos = pos;
    this.vel = vel;
    this.acc = new PVector(0, 0);
  }
  
  Particle (PVector pos, PVector vel, PVector acc) {
    this.pos = pos;
    this.vel = vel;
    this.acc = acc;
  }
  
  public void run() {
    update();
    draw();
  }
  
  public void update() {
    vel.add(acc);
    pos.add(vel);
  }
  
  public void draw() {
    fill(255);
    noStroke();
    ellipse(pos.x, pos.y, 5, 5);
  }
  
  public boolean isDead() {
    return pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height;
  }
  
  public void respawn() {}
}

class Spring extends Particle {
  //float k = 0.025;
  float k = 0.0025f;
  float target_height;
  float damping = 0.03f;
  
  Spring(PVector pos) {
    super(pos);
    target_height = pos.y;
  }
  
  public void update() {
    float dist_y = pos.y - target_height;
    acc.y = (-k * dist_y) - (damping * vel.y);
    super.update();
  }
  
  public void perturb() {
    Ani.to(this.pos, 0.1f, "y", random(target_height - 50, target_height + 50));
  }
  
  public void perturbRain() {
    Ani.to(this.pos, 0.1f, "y", random(target_height + 10, target_height + 40));
  }
  
  
  public float getSpringHeight() {
    return pos.y;
  }
  
  public float getHeightDiff() {
    return pos.y - target_height;
  }
}

class SplashDrop extends Particle {
  float lifespan = 20;
  char letter;
  int font_size = 9;
  
  SplashDrop(PVector p, PVector v, PVector a, char l) {
    super(p, v, a);
    letter = l;
  }
  
  public void update() {
    lifespan --;
    super.update();
  }
  
  public void draw(boolean letters) {
    if (letters) {
      float theta = map(pos.x,0,width,0,TWO_PI*2);
      fill(200, min(255, lifespan*30));
      textSize(font_size);
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(theta);
      text(letter, 0, 0);
      popMatrix(); 
    } else {
      noStroke();
      fill(200, min(255, lifespan*30));
      ellipse(pos.x, pos.y, 2, 2);
    }
  }
  
  public boolean isDead() {
    return lifespan < 0;
  }
}

class RainDrop extends Particle {
  String word;
  int font_size = 8;
  float word_width;
  int shade = (int)random(70, 170);
  
  RainDrop(PVector p, PVector v, PVector a, String w) {
    super(p, v, a);
    word = w;
    textSize(font_size);
    word_width = textWidth(w);
  }
 
  public void respawn(boolean stop) {
    pos.x = random(4, width-4);
    pos.y = -random(50);
    vel.y = stop ? 0 : 10;
    acc.y = stop ? 0 : 0.1f;
  }
  
  public void draw(boolean letters) {
    if (letters) {
      fill(shade);
      textSize(font_size);
      noStroke();
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(-HALF_PI);
      text(word, 0, 0);
      popMatrix();
    } else {
      fill(200);
      stroke(200);
      ellipse(pos.x, pos.y, 2, 2);
    }
  }
}
class MultiRain {
  Rain[] rains;
  Splashing sp;
  
  MultiRain(MultiWave mw, Splashing sp, String[] words, int n) {
    this.sp = sp;
    rains = new Rain[mw.waves.length];
    for (int i = 0; i < mw.waves.length; i++) {
      Rain r = new Rain(words, n, mw.waves[i]);
      rains[i] = r;
    }
    //restart();
  }
  
  public void run(boolean letters, boolean raining) {
    for (int i = 0; i < rains.length; i++) {
      rains[i].run(sp, letters, raining);
    }
  }
  
  public void restart() {
    for (int i = 0; i < rains.length; i++) {
      rains[i].restart();
    }
  }
}

class Rain {
  ArrayList<RainDrop> rain;
  Wave target_wave;
  int n = 12;
  
  Rain(String[] words, int n, Wave target_wave) {
    this.target_wave = target_wave;
    this.n = n;
    rain = new ArrayList<RainDrop>();
    for (int i = 0; i < n; i++) {
      int w_index = floor(random(words.length));
      String word = words[w_index];
      
      RainDrop r = new RainDrop(new PVector(random(4, width-4), -i*150),
                                new PVector(0, 0),
                                new PVector(0, 0.0f), word);
      rain.add(r);                          
    }
  }
  
  public void run(Splashing sp, boolean letters, boolean raining) {
    Iterator<RainDrop> it = rain.iterator();
    while(it.hasNext()) {
      RainDrop r = it.next();
      
      r.update();
      r.draw(letters);
      
      if (r.pos.y > target_wave.target_height) {
        Spring s = target_wave.getSelectedSpring((int)r.pos.x);
        r.respawn(!raining);
        s.perturbRain();
        sp.createSplash(s.pos.x, s.pos.y);
      }
    }    
  }
  
  public void restart() {
    for (int i = 0; i < n; i++) {
      RainDrop r = rain.get(i);
      if (r.pos.y < 0) {
        r.pos.y = -i*150;
        r.vel.y = 10;
        r.acc.y = g.y;
      }
    }
  }
}

class Splashing {
  ArrayList<SplashDrop> droplets;
  int pps = 6;  // particles per splash
  float splash_speed = 4.5f;
  
  Splashing() {
    droplets = new ArrayList<SplashDrop>();
  }
  
  public void run(boolean letters) {
    Iterator<SplashDrop> it = droplets.iterator();
    while (it.hasNext()) {
      SplashDrop p = it.next();
      p.update();
      p.draw(letters);
      if (p.isDead()) {
        it.remove();
      }
    }
  }
  
  public void createSplash(float x, float y) {
    for (int i = 0; i < pps; i ++) {
      float radians = random(0, PI);
      PVector v = new PVector(splash_speed*cos(radians)/2 + random(-1, 1),
                              -splash_speed*sin(radians) + random(-1, 1));
      PVector p = new PVector(x + random(-5, 5), y + random(-12, 12));
      PVector a = new PVector(0, .3f);
      
      char c = (char) PApplet.parseInt(random(97, 122));
      droplets.add(new SplashDrop(p, v, a, c));
    }
  }
}
class Wave {
  Spring[] springs;
  float[] leftDeltas;
  float[] rightDeltas;
  
  float radius;
  float target_height;
  float spread = 0.48f;
  
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
  
  public void initText(String[] words, float fs, int start_spring, int end_spring) {
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
  public Spring getSelectedSpring(int x) {
    return springs[floor((x-springs[0].pos.x) / (radius * 2))];
  }
  
  public int getSelectedSpringIndex(int x) {
    return floor((x-springs[0].pos.x) / (radius * 2));
  }
  
  public void startWaving() {
    float max_amp = random(40, 80);
    float stillness = random(3, 8);
    float ramp_up = random(2, 5);
    end = (frameRate%2 ==0) ? 0 : springs.length - 1; // which side of the wave to start on?
    Ani.to(this, ramp_up, stillness, "amplitude", max_amp, Ani.SINE_IN_OUT, "onEnd:endWaving");
  }
  
  public void endWaving() {
    float wave_duration = random(1, 3);
    float ramp_down = random(2, 5);
    Ani.to(this, ramp_down, wave_duration, "amplitude", 0, Ani.SINE_IN_OUT, "onEnd:startWaving");
  }
  
  public void perturbRegion(int left, int right, float y, Splashing sp) {
    left = max(0, left);
    right = min(springs.length - 1, right);
    for (int i = left; i < right; i++) {
      springs[i].pos.y = y;
    }
    sp.createSplash(springs[left].pos.x, target_height);
    sp.createSplash(springs[right].pos.x, target_height);
    sp.createSplash(springs[(int)(left + (right-left)/2)].pos.x, target_height);
  }
  
  public void update() {
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
    for (int i = 0; i < springs.length; i++) {
      springs[i].update();
    }
    
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
  
  public void draw(boolean letters) {
    fill(shade);  
    if (letters) {
      if (texts == null) {
        draw(false);
        return;
      } 
      drawTexts();
      
    } else {
      stroke(shade);
      for (int i = 0; i < springs.length; i++) {
        ellipse(springs[i].pos.x, springs[i].pos.y, radius, radius);
      }
    }
  }
  
  public void drawTexts() {
    Iterator<WavyText> it = texts.iterator();
      while(it.hasNext()) {
        WavyText wt = it.next();
        wt.draw(springs, radius*2);
      }
  }
}
class WavyText {
  String text;
  int len;
  float font_size;
  
  PVector start_pos;
  PVector vel;
  
  WavyText(String t, float fs, float x, float y) {
    text = t;
    len = t.length();
    font_size = fs;
    
    start_pos = new PVector(x, y);
    vel = new PVector(2, 0);
  }
  
  public void update() {
    start_pos.add(vel);
  }
  
  public void draw(Spring[] springs, float spring_width) {
    textSize(font_size);
    
    float caret_x = 0;
    int selected_spring;
    
    for (int i = 0; i < len; i++) {
      char next_letter = text.charAt(i);
      float x = start_pos.x - springs[0].pos.x + caret_x;
      
      // find the spring associated with the letter
      selected_spring = (int) (x / spring_width);
      if (selected_spring >= springs.length || selected_spring < 0) {
        return;
      }
      
      float y = start_pos.y + springs[selected_spring].getHeightDiff();
      text(next_letter, x + springs[0].pos.x, y);
      caret_x += textWidth(next_letter);
    }
  }
}
  public void settings() {  fullScreen(P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "X041_WaveScene" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
