// 9.29.16
//
// Scrolling Text Wave
//
// Text that moves along with the wave!

Wave w;
boolean drawLetters;
int font_size = 24;
PFont font;

ScrollingWavyText swt;

void setup() {
  size(600, 600, P2D);
  background(30);
  
  w = new Wave(new PVector(-8, 450), new PVector(602, 450), 4);
  
  font = createFont("American Typewriter", font_size);
  textFont(font, font_size);
  
  swt = new ScrollingWavyText("Hello World", font_size, 30, 450);
}

void draw() {
  background(30);
  swt.update();
  swt.draw(w.springs, w.radius*2);
  
  w.update();
  w.draw(drawLetters);
}