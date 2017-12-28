class Wheel {
  float radius = 100;
  float x;
  float y;
  float diameter = radius * 2;
  float rotation = TWO_PI;
  float angle_to_turn = 0.01;
  float distance_traveled = 0;

  int letter_index = 0;
  float letter_angle = 0;

  public Wheel(float radius, float x, float y) {
    this.radius = radius;
    this.diameter = radius * 2;
    this.y = y;
    this.x = x;
  }
  
  public void setTurnAmount(float angle) {
    angle_to_turn = angle;
  }  

  public void draw() {
    pushMatrix();
    translate(x + distance_traveled, y);
    rotate(rotation);
    drawTextCircle();
    drawSpokes();
    popMatrix();
  }

  public void goForward() {
    rotation += angle_to_turn;
    rotation %= TWO_PI;
    distance_traveled = radius * rotation;
  }

  public void goBack() {
    rotation -=angle_to_turn;
    distance_traveled = radius * rotation;
  }


  public void drawTextCircle() {
     while(letter_angle < TWO_PI) {
       char next_letter = phrase.charAt(letter_index);
       float letter_width = textWidth(next_letter);
       
       float letter_x = cos(letter_angle) * radius;
       float letter_y = sin(letter_angle) * radius;
 
       pushMatrix();
       translate(letter_x, letter_y);
       rotate(letter_angle + PI/2);
       text(next_letter, 0, 0);
       popMatrix();
     
       letter_angle += letter_width/radius;
       letter_index ++; 
       letter_index %= phrase.length();
     }
     letter_angle = 0;
     letter_index = 0;
  }

  private void drawSpokes() {
    for (int i = 0; i < 360; i += 60) {
      pushMatrix();
      rotate(radians(i));
      translate(10, 0);
      text(phrase, 0, 0);
      popMatrix();
    }
  }

  private void drawCircle() {
    strokeWeight(20);
    stroke(255);
    noFill();
    ellipse(0, 0, diameter, diameter);
  
    noStroke();
    fill(255);
    for (int i = 0; i < 360; i+=60) {
      pushMatrix();
      rotate(radians(i));
      rect(0, 0, radius, 10);
      popMatrix();
    }
    fill(0);
    ellipse(0, 0, 10, 10);
  }

}