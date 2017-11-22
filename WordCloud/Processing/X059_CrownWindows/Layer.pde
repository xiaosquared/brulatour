class Layer {
  float lower_bound;
  float upper_bound;
  float position;
  float thickness; 
  float length;
  
  public Layer(float lower_bound, float upper_bound, float position, float thickness) {
    this.lower_bound = min(lower_bound, upper_bound);
    this.upper_bound = max(lower_bound, upper_bound);
    this.position = position;
    this.thickness = thickness;
    this.length = upper_bound - lower_bound;
    
  }
  
  public void extendTo(float new_bound) {
    lower_bound = min(new_bound, lower_bound);
    upper_bound = max(new_bound, upper_bound);
    length = upper_bound - lower_bound;
    println(lower_bound + ", " + upper_bound);
  }
  
  public void extendLowerBy(float amount) {
    lower_bound -= amount;
    length = upper_bound - lower_bound;
  }
  
  public void extendUpperBy(float amount) {
    upper_bound += amount;
    length = upper_bound - lower_bound;
  }
  
  // by default draws a horizontal layer
  public void draw() {
    rect(lower_bound, position-thickness, length, thickness);
  }
}

class VerticalLayer extends Layer {
  public VerticalLayer(float lower_bound, float upper_bound, float position, float thickness) {
    super(lower_bound, upper_bound, position, thickness);
  }
  
  public void draw() {
    rect(position, lower_bound, thickness, length);
  }
}