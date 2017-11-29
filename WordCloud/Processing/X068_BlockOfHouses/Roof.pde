class Roof extends Wall {
  float angle;
  float width_top;
  PVector tl_trap;  // top left of trapezoid. tl denotes the top left of the bounding box
  
  public Roof(float x, float y, float width, float height, float angle, float layer_thickness, int hue) {
    super(x, y, width, height, layer_thickness, hue);
    
    createIncline(x, y, angle);
  }
  
  // triangular roof
  public Roof(float x, float y, float width, float height, float layer_thickness, int hue) {
    super(x, y, width, height, layer_thickness, hue);
    
    createIncline(x, y, atan(width/2 /height));
  }
  
  void createIncline(float x, float y, float angle) {
    float tan = tan(angle);
    float shorter = height*tan;
    width_top = width - shorter *2;
    tl_trap = new PVector(x+shorter, y);
    
    for (Layer l : layers) {
      shorter = (y + height - l.position) * tan;
      l.lower_bound += shorter;
      l.upper_bound -= shorter;
      l.length = l.upper_bound - l.lower_bound;
      l.slots.clear();
      l.slots.add(new Slot(l.lower_bound, l.upper_bound));
    }
  }
  
  void drawOutline() {
    line(tl_trap.x, tl_trap.y, tl_trap.x+width_top, tl_trap.y);
    line(tl.x, br.y, br.x, br.y);
    line(tl_trap.x, tl_trap.y, tl.x, br.y);
    line(tl_trap.x+width_top, tl_trap.y, br.x, br.y); 
  }
  
}