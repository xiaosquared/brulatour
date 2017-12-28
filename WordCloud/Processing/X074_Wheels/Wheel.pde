class Wheel {
  float radius = 100;
  float y;
  float diameter = radius * 2;
  float rotation = 0;
  float angle_to_turn = 0.05;
  float distance_traveled = 0;

  public Wheel(float radius, float y) {
    this.radius = radius;
    this.y = y;
  }
  
  public void setTurnAmount(float angle) {
    angle_to_turn = angle;
  }

  public void draw() {
    translate(distance_traveled, y);
    drawCircle(rotation);
  }

  public void turn() {
    rotation += angle_to_turn;
    distance_traveled = radius * rotation;
    if (distance_traveled > width + radius) {
      rotation = -PI/3;
    }
  }

  private void drawCircle(float rotation) {
    pushMatrix();
    rotate(rotation);
  
    strokeWeight(10);
    stroke(255);
    noFill();
    ellipse(0, 0, diameter, diameter);
  
    noStroke();
    fill(255);
    for (int i = 0; i < 360; i+=60) {
      pushMatrix();
      rotate(radians(i));
      rect(0, 0, 100, 10);
      popMatrix();
    }
    fill(0);
    ellipse(0, 0, 10, 10);
  
    popMatrix();
  }

}