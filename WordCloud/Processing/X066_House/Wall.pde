class Wall {
  PVector tl;
  PVector br;
  
  float width;
  float height;
  
  ArrayList<Layer> layers;
  int layer_index = 0;
  float layer_thickness;
  
  ArrayList<Brick> bricks;
  boolean isFilled = false;
  float min_brick_width = 5;
  float max_height_scale = 5;
 
  int hue;
 
  public Wall() {
    bricks = new ArrayList<Brick>();
  }
 
  public Wall(float x, float y, float width, float height, float layer_thickness, int hue) {
    tl = new PVector(x, y);
    br = new PVector(x + width, y + height);
    this.width = width;
    this.height = height;
    this.layer_thickness = layer_thickness;
    
    layers = new ArrayList<Layer>();
    int num_layers = floor(height/layer_thickness);
    for (int i = 0; i < num_layers; i++) {
      float layer_y = y + height - (i * layer_thickness);
      layers.add(new Layer(x, x+width, layer_y, layer_thickness));
    }
    
    bricks = new ArrayList<Brick>();
    
    this.hue = hue;
  }

  public Wall(float x, float y, float width, float height, float layer_thickness) {
    this(x, y, width, height, layer_thickness, floor(random(0, 360)));
  }

  public void reset() {
    for (Layer l : layers)
      l.reset();
    
    bricks.clear();
    isFilled = false;
    layer_index = 0;
  }

  public boolean addWordBrick(Word word, boolean featured) {
    if (isFilled)
      return false;
    
    //if (layer_index >= layers.size())
    //  return false;
    
    float height_scale = 1;
    if (featured) {
      height_scale = floor(random(1, min(max_height_scale, layers.size()-layer_index)));
    } 
     
    float brick_height = layer_thickness * height_scale;
    float brick_width = brick_height * word.getRatio();
    
    Layer current_layer = layers.get(layer_index);
    Brick brick = current_layer.addWordBrick(word, brick_width, min_brick_width, brick_height);
   
    if (brick != null) {
       bricks.add(brick);
       brick.setColor(hue, floor(random(50, 100)), floor(random(50, 100)));
      
      if (height_scale > 1) {
        for (int i = 0; i < height_scale; i++) {
          Layer upper_layer = layers.get(layer_index + i);
          ArrayList<Slot> overlaps = upper_layer.getOverlappingSlots(brick.getMinX(), brick.getMaxX());
          if (overlaps.size() > 0) {
            for (Slot upper_slot : overlaps)
              upper_layer.subdivideSlot(upper_slot, brick.getMinX(), brick.getMaxX(), min_brick_width);
          }
        }
      }
    }
    
    if (brick == null)
      return false;
    else
      return true;
  }
  
  public boolean currentLayerFull() {
    return layers.get(layer_index).isFilled();
  }
  
  public void advanceLayerIndex() {
    if (layer_index+1 == layers.size()) 
      isFilled = true;
    else
      layer_index++;
  }
  
  //public ArrayList<CrownWindow> addCrownWindows(int num, float top_margin, 
  //                                              float bottom_margin, float side_margin, 
  //                                              float in_between, float gap, int hue) {
    
  //  ArrayList<CrownWindow> windows = new ArrayList<CrownWindow>();
  //  float win_width = (width - 2 * side_margin - (num-1) * in_between)/num;  
  //  float win_height = height - top_margin - bottom_margin;
    
  //  for (int i = 0; i < num; i++) {
  //    PVector w_tl = new PVector(tl.x + side_margin + i * (in_between + win_width), 
  //                              tl.y + top_margin);
  //    PVector w_br = new PVector(w_tl.x + win_width, w_tl.y + win_height);              
  //    CrownWindow w = new CrownWindow(w_tl, w_br, layer_thickness, hue);
  //    windows.add(w);
  //  }
    
  //  // segment wall's layers
  //  // starting from the bottom, get the first wall layer that is relevant
    
  //  int index = 0;
  //  Layer current_wall_layer = layers.get(index);
  //  Layer current_window_layer;
  //  while(current_wall_layer.position > br.y - bottom_margin) {
  //    index++;
  //    current_wall_layer = layers.get(index);
  //  }
    
  //  // since wall and window layers are the same thickness, we will just increment both
  //  int num_gap_layers = ceil(gap/layer_thickness);
    
  //  for (int j = 0; j < num; j++) {
  //    CrownWindow w = windows.get(j);
     
  //    // this is for the bottom gap
  //    current_window_layer = w.layers.get(0);
  //    for (int i = 0; i < num_gap_layers; i++) {
  //      if (index - i < 0)
  //        break;
  //      current_wall_layer = layers.get(index - i);
  //      if (current_wall_layer != null) {
  //        divideWall(current_wall_layer, current_window_layer, gap);
  //      }
  //    }
      
  //    // this is for the top gap
  //    for (int i = w.getLayers().size() - 1; i > num_gap_layers; i--) {
  //      current_window_layer = w.layers.get(i);
  //      current_wall_layer = layers.get(index + num_gap_layers + i);
  //      if (current_wall_layer != null) {
  //        divideWall(current_wall_layer, current_window_layer, gap);
  //      }
  //    }

  //    // this is for the main area of the window
  //    for (int i = 0; i < w.getLayers().size(); i++) {
  //      current_window_layer = w.getLayers().get(i);
  //      current_wall_layer = layers.get(index + i);
      
  //      divideWall(current_wall_layer, current_window_layer, gap);
  //    }
       
  //  }
  //  return windows;
  //}
  
  // helper function
  void divideWall(Layer current_wall_layer, float lower_bound, float upper_bound, float gap) {
    
    ArrayList<Slot> overlaps = current_wall_layer.getOverlappingSlots(lower_bound, upper_bound);
    if (overlaps.size() > 0) {
      for (Slot slot : overlaps) 
      current_wall_layer.subdivideSlot(slot, lower_bound - gap, upper_bound + gap, 1);
    }
  }
  
  void addHole(PVector tl, PVector br, float gap) {
    int top_index = 0;
    int bottom_index = layers.size();
    
    for (int i = 0 ; i < layers.size(); i++) {
      Layer wall_layer = layers.get(i);
      if (wall_layer.position > tl.y && wall_layer.position < br.y) {
        
        bottom_index = min(bottom_index, i);
        top_index = max(top_index, i);
        
        divideWall(wall_layer, tl.x, br.x, gap); 
      }
    }
    
    // deal with top and bottom gaps
    int num_gap_layers = ceil(gap*1.2/layer_thickness);
    for (int i = 0; i < num_gap_layers; i++) {
      if (top_index + i >= layers.size())
        break;
      Layer wall_layer = layers.get(top_index + i);
      divideWall(wall_layer, tl.x, br.x, gap); 
    }
    
    num_gap_layers = ceil(gap*1.5/layer_thickness);
    for (int i = 0; i < num_gap_layers; i++) {      
      if (bottom_index - i < 0 || bottom_index - i >= layers.size()) 
        break;
      Layer wall_layer = layers.get(bottom_index - i);
      divideWall(wall_layer, tl.x, br.x, gap);
    }
  }
  
  void fillAll() {
    while(!isFilled) {
      addWord();
      checkLayer();
    }
  }
  
  void addWord() {
    word = wm.getRandomWord();
      if (!addWordBrick(word, true))
        addWordBrick(wm.getRandomWord(), false);
  }
  
  void checkLayer() {
    if (currentLayerFull()) {
         advanceLayerIndex(); 
    }
  }
  
  public void draw() {
    //drawOutline();
    drawLayers();
    drawWords();
  }
  
  public void draw(boolean outline, boolean layers, boolean words) {
    if (outline)
      drawOutline();
    if (layers)
      drawLayers();
    if (words)
      drawWords();
  }
  
  void drawWords() {
    //stroke(200);
    for (Brick b : bricks) {
      b.draw(false);
    }
  }
  
  void drawOutline() {
    stroke(200);
    noFill();
    rect(tl.x, tl.y, width, height);
  }
  
  void drawLayers() {
    noStroke();
    fill(hue, 100, 100);
    for (Layer l : layers) {
      l.draw();
    }
  }
}