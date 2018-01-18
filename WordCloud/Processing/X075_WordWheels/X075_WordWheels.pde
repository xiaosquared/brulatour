// 12.27.17
//
// Wheels
//
// A wheel made of words 
//


Wheel w, w2, w3;

PFont font;
String phrase = "hello world ~ ";

void setup() {
  size(600, 600);
  background(0);
  
  font = createFont("American Typewriter", 20);
  textFont(font, 14);
  
  w = new Wheel(100, width/2, height/2);
  w.setTurnAmount(0.05);  
  println("go");
}

void draw() {
  //background(0);
  
}


void keyPressed() {
   if (keyCode == 39) {
     // go forward
     w.goForward();
   }
   else if (keyCode == 37) {
     // go backward
     w.goBack();
   }
   
   background(0);
   w.draw();
   
   if (key == 32) {
     
   }
}