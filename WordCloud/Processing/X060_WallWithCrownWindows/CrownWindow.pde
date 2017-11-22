class CrownWindow extends Wall {
  
  public CrownWindow() {
    layers = new ArrayList<Layer>();
  }
  
  public ArrayList<Layer> getLayers() {
    return layers;
  }
  
  public CrownWindow(PVector top_left, PVector bottom_right, float layer_thickness, int hue) {
    super(top_left.x, top_left.y, bottom_right.x - top_left.x, bottom_right.y - top_left.y, layer_thickness, hue);  
    
    layers = new ArrayList<Layer>();
    
    //int num_layers = floor((bottom_right.y - top_left.y) / layer_thickness);
    float circle_radius = (bottom_right.x - top_left.x)/2;
    
    float circle_center_y = top_left.y + circle_radius;
    float circle_center_x = top_left.x + (bottom_right.x - top_left.x)/2;
    
    float y = bottom_right.y;
    boolean entered_circle = false;
    
    while(y >= top_left.y) {
      // rectangular part
      if (!entered_circle) {
        Layer l = new Layer(top_left.x, bottom_right.x, y, layer_thickness);
        layers.add(l);
      }
      
      // circular part
      else {
        float val = sqrt(sq(circle_radius) - sq(y - circle_center_y));
        float lower_bound = circle_center_x - val;
        float upper_bound = circle_center_x + val;
        if (upper_bound - lower_bound > 5) {
          Layer l = new Layer(lower_bound, upper_bound, y, layer_thickness);
          layers.add(l);
        }
      }
      
      // update y
      y -= layer_thickness;
      if (y < circle_center_y) {
        entered_circle = true;
      }
    }
  }
  
  public void draw() {
    for (Layer l : layers) {
      l.draw();
    }
    drawWords();
  }
}

// same shape but with vertical slices
class CrownWindowVertical extends CrownWindow {
  public CrownWindowVertical(PVector top_left, PVector bottom_right, float layer_thickness) {
    float circle_radius = (bottom_right.x - top_left.x)/2;
    int num_layers = floor(circle_radius / layer_thickness);
    
    float sliced_width = num_layers * layer_thickness;
    float center_x = top_left.x + (bottom_right.x - top_left.x)/2;
    float center_y = top_left.y + circle_radius;
    float start_x = center_x - sliced_width;
    
    float right_bound = bottom_right.y;
    
    // left half 
    for (int i = 0; i < num_layers; i++) {
      float x = start_x + i * layer_thickness;
      float left_bound = center_y - sqrt(sq(circle_radius) - sq(x - center_x));
    
      if (right_bound - left_bound >= 5) {
        Layer l = new LayerVertical(left_bound, right_bound, x, layer_thickness);
        layers.add(l);
      }
    }
    // right half
    for (int i = 1; i <= num_layers; i++) {
      float x = center_x + i * layer_thickness;
      float left_bound = center_y - sqrt(sq(circle_radius) - sq(x - center_x));
      if (right_bound - left_bound >= 5) {
        Layer l = new LayerVertical(left_bound, right_bound, x-layer_thickness, layer_thickness);
        layers.add(l);
      }
    }
  }
}