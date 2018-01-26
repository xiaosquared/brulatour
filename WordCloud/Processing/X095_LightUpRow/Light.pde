class Light {
  
  PVector pos;
  float diameter;
  boolean isOn;
  
  public Light(float x, float y, float diameter, boolean isOn) {
    this.pos = new PVector(x, y);
    this.diameter = diameter;
    this.isOn = isOn;
  }
  
  public void draw() {
    stroke(255);
    if (isOn) { fill(255); } 
    else { fill(0); }
    ellipse(pos.x, pos.y, diameter, diameter);
  }
}