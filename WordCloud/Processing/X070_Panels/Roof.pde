class Roof extends Story implements Fillable {
  float angle;
  float width_top;
  PVector tl_trap;  // top left of trapezoid. tl denotes the top left of the bounding box

  public Roof(float x, float y, float width, float height, float angle, float layer_thickness, int hue) {
    super(x, y, width, height, layer_thickness, hue);
    
    this.angle = angle;
    createIncline(x, y, angle);
  }
  
  // triangular roof
  public Roof(float x, float y, float width, float height, float layer_thickness, int hue) {
    super(x, y, width, height, layer_thickness, hue);
    
    angle = atan(width/2 /height);
    createIncline(x, y, atan(width/2 /height));
  }
  
  
 void createIncline(float x, float y, float angle) {
   createIncline(main, x, y, angle);  
 }
  
  void createIncline(Wall wall, float x, float y, float angle) {
    float tan = tan(angle);
    float shorter = height*tan;
    width_top = width - shorter *2;
    tl_trap = new PVector(x+shorter, y);
    
    for (Layer l : wall.layers) {
      shorter = (y + height - l.position) * tan;
      l.lower_bound += shorter;
      l.upper_bound -= shorter;
      l.length = l.upper_bound - l.lower_bound;
      l.slots.clear();
      l.slots.add(new Slot(l.lower_bound, l.upper_bound));
    }
  }
  
   void addPointedWindow(int num, float top_margin, float bot_margin, float side_margin, float in_between, float gap, int hue) {
    this.gap = gap;
    float win_width = (main.width - 2 * side_margin - (num-1) * in_between)/num;
    float win_height = main.height - top_margin - bot_margin;
    
    float win_y = main.tl.y + top_margin;
    for (int i = 0; i < num; i++) {
      float win_x = main.tl.x + side_margin + i * (in_between + win_width);
      PointedWindow win = new PointedWindow(win_x, win_y, win_width, win_height, layer_thickness, hue);
      windows.add(win);
    }
    
    if (bot_margin > 0) {
      splitWall(win_y + win_height);
      createIncline(main.tl.x, main.tl.y, angle);
      createIncline(base, main.tl.x, main.tl.y, angle); 
    }
    
    Layer current_window_layer;
    Layer current_wall_layer;
    for (Wall win : windows) {
      
      for (int i = 0; i < win.layers.size(); i++) {
          current_window_layer = win.layers.get(i);
          current_wall_layer = main.layers.get(i);
      
          main.divideWall(current_wall_layer, current_window_layer.lower_bound, 
                          current_window_layer.upper_bound, gap);
      }
      
      int num_gap_layers = ceil(gap/layer_thickness);
      for (int i = win.layers.size() -1 ; i > num_gap_layers; i--) {
        current_window_layer = win.layers.get(i);
        if (num_gap_layers + i >= main.layers.size())
          break;
        current_wall_layer = main.layers.get(ceil(num_gap_layers * 1.2 + i));  
        if (current_wall_layer != null) {
          main.divideWall(current_wall_layer, current_window_layer.lower_bound, 
                          current_window_layer.upper_bound, gap);
        }
      }
    }
  }
  
  void drawOutline() {
    stroke(255);
    
    Wall bw;
    if (base != null) {
      bw = base;
    } else {
      bw = main;
    }
    
    line(tl_trap.x, tl_trap.y, tl_trap.x+width_top, tl_trap.y);
    line(bw.tl.x, bw.br.y, bw.br.x, bw.br.y);
    line(tl_trap.x, tl_trap.y, bw.tl.x, bw.br.y);
    line(tl_trap.x+width_top, tl_trap.y, bw.br.x, bw.br.y);
    
  }
  
  void draw(boolean outline, boolean layers, boolean words) {
    main.draw(false, layers, words);
    if (outline)
      drawOutline();
    
    if (base != null) 
      base.draw(outline, layers, words);
    
    if (railing != null) {
      railing.draw(outline, layers, words);
    }
    
    for (Wall win : windows) {
      win.draw(outline, layers, words);
    }
  }
  
}