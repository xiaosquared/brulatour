class Stanchion {
  float x, y, width, height;
  float layer_size;
  
  ArrayList<Layer> layers;
  int current_layer_index = 0;
  
  ArrayList<Brick> bricks;
  boolean isFilled = false;
  float min_brick_width;
  float max_height_scale;
  
  public Stanchion(float x, float y, float width, float height, float layer_width,
                    float min_brick_width, float max_height_scale) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.layer_size = layer_width;
    this.min_brick_width = min_brick_width;
    this.max_height_scale = max_height_scale;
  
    layers = new ArrayList<Layer>();
    int num_layers = floor(width/layer_width);
    for (int i = 0; i < num_layers; i++) {
      float layer_x = x + i * layer_width;
      layers.add(new Layer(y, y + height, layer_x, layer_width, true));
    }
    current_layer_index = 0;
    
    bricks = new ArrayList<Brick>();
  }
 
  public boolean addWordBrick(Word word, boolean featured) {
    if (isFilled)
      return false;
     
    float word_size_scale = 1;
    if (featured) {
      word_size_scale = floor(random(1, min(max_height_scale, layers.size()-current_layer_index)));
    }
    
    float brick_height = layer_size * word_size_scale;
    float brick_width = brick_height * word.getRatio();
    
    Layer current_layer = layers.get(current_layer_index);
    Brick brick = current_layer.addWordBrick(word, brick_width, min_brick_width, brick_height);
   
    if (brick != null) {
      bricks.add(brick);
      brick.fill_color = floor(random(100, 220));
      
      if (word_size_scale > 1) {
        for (int i = 0; i < word_size_scale; i++) {
          Layer upper_layer = layers.get(current_layer_index + i);
          Slot upper_slot = upper_layer.getOverlappingSlot(brick.getLowerBound(), brick.getUpperBound());
          
          if (upper_slot != null) {
            upper_layer.subdivideSlot(upper_slot, brick.getLowerBound(), brick.getUpperBound(), min_brick_width);
          }
        }
      }
    }
    
    if (current_layer.isFilled()) {
      current_layer_index++;
      if (current_layer_index == layers.size()) {
        isFilled = true;
      }
    }
    
    if (brick == null)
      return false;
    else
      return true;
  }
  
  void draw() {
    //drawOutline();
    //drawLayers();
    drawBricks();
  }
  
  void drawOutline() {
    stroke(200);
    noFill();
    rect(x, y, width, height);
  }
  
  void drawLayers() {
    noStroke();
    fill(100, 100, 250);
    for (Layer l : layers) {
      l.draw(2);
    }
  }
  
  void drawBricks() {
    stroke(200, 150);
    fill(random(100, 200), random(100, 200));
    for (Brick b : bricks) {
      b.draw(false);
    }
  }
}