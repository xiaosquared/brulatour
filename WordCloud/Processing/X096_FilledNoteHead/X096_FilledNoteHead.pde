// 1.28.17
//
// Spiral
//
// For light up notes
// Filling the note head with a spiral

float MAX_RADIUS = 10;

void setup() {
  size(500, 500);
  
  background(0);
  stroke(250);

}

void draw() {
    background(0);
  
    textSize(10);
    
    String str = "hello world ~";
    float radius = textWidth(str.charAt(0));
    int i = 0;
    //so we are rotating around the center, rather than (0,0):
    translate(width/2, height/2); 
    while (radius < MAX_RADIUS) {
      radius += 0.2;
      char letter = str.charAt(i);
      float arclen = textWidth(letter);
      float theta = arclen/radius;

      rotate(theta);
      text(letter, 0, radius);
      i ++; i %=str.length();
    }
}