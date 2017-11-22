class Layer {
  float left_boundary;
  float right_boundary;
  float size;
  float position;
  float layer_height; 
  
  boolean isVertical;
  
  public Layer(float left, float right, float position, float layer_height, boolean isVertical) {
    left_boundary = left;
    right_boundary = right;
    this.position = position;
    this.layer_height = layer_height;
    this.size = right_boundary - left_boundary;
    
    this.isVertical = isVertical;
  }
  
  public void draw() {
    if (isVertical) {
      rect(position, left_boundary, layer_height, size); 
    }
    else {
      rect(left_boundary, position, size, layer_height);
    }
  }
}