class ArchWindow extends Wall {
  
  public ArchWindow(float x, float y, float width, float height, float layer_thickness, int hue) {
    this(new PVector(x, y), new PVector(x+width, y+ height), layer_thickness, hue);
  }
  
  public ArchWindow(PVector top_left, PVector bottom_right, float layer_thickness, int hue) {
    super(top_left.x, top_left.y, bottom_right.x - top_left.x, bottom_right.y - top_left.y, layer_thickness, hue);  
    
    layers = new ArrayList<Layer>();
   
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
}

class PointedWindow extends Wall {
  
  float angle = 55;
  
  public PointedWindow(float x, float y, float width, float height, float layer_thickness, int hue) {
    this(new PVector(x, y), new PVector(x+width, y+ height), layer_thickness, hue);
  }
  
  public PointedWindow(PVector top_left, PVector bottom_right, float layer_thickness, int hue) {
    super(top_left.x, top_left.y, bottom_right.x - top_left.x, bottom_right.y - top_left.y, layer_thickness, hue);  
    
    float tan_angle = tan(radians(angle));
    
    float triangle_height = width/2 / tan_angle;
    

    for (int i = layers.size()-1; i >= 0; i--) {
      Layer l = layers.get(i);

      if (l.position > tl.y + triangle_height)
        break;
      float adjacent = triangle_height - (l.position - tl.y);
      float opposite = tan_angle * adjacent;

      l.extendLowerBy(-opposite);
      l.extendUpperBy(-opposite);
    }
  }
}