class Trapezoid {
  PVector tl, tr, bl, br;
  float min_y, max_y;
  
  ArrayList<Layer> layers;
  float layer_height = 15;
  int current_layer_index = 0;
  
  ArrayList<Rectangle> holes;

  ArrayList<Brick> bricks;
  boolean isFilled = false;
  float min_brick_width;
  float max_height_scale;

  public Trapezoid(PVector tl, PVector tr, PVector bl, PVector br, float layer_height, 
                  float min_brick_width, float max_height_scale) {
    this.tl = tl;
    this.tr = tr;
    this.bl = bl;
    this.br = br;
    this.layer_height = layer_height;

    min_y = tr.y;
    max_y = br.y;
    this.min_brick_width = min_brick_width;
    this.max_height_scale = max_height_scale;
    
    holes = new ArrayList<Rectangle>();
    
    layers = new ArrayList<Layer>();
    int num_layers = floor((bl.y - tl.y)/layer_height);
    for (int i = 0; i < num_layers; i++) {
      float layer_y = max_y - i * (layer_height);
      float left = lerp(bl.x, tl.x, (float)i/num_layers);
      float right = lerp(br.x, tr.x, (float)i/num_layers);
      layers.add(new Layer(left, right, layer_y, layer_height));
    }
    current_layer_index = 0;

    bricks = new ArrayList<Brick>();
  }

  public boolean addWordBrick(Word word, boolean featured) {
    if (isFilled)
      return false;
    
    float height_scale = 1;
    if (featured) {
      height_scale = floor(random(1, min(max_height_scale, layers.size()-current_layer_index)));
    } 
     
    float brick_height = layer_height * height_scale;
    float brick_width = brick_height * word.getRatio();
    
    Layer current_layer = layers.get(current_layer_index);
    Brick brick = current_layer.addWordBrick(word, brick_width, min_brick_width, brick_height);
   
    if (brick != null) {
      bricks.add(brick);
      brick.fill_color = floor(random(100, 220));
      
      if (height_scale > 1) {
        for (int i = 0; i < height_scale; i++) {
          Layer upper_layer = layers.get(current_layer_index + i);
          Slot upper_slot = upper_layer.getOverlappingSlot(brick.getMinX(), brick.getMaxX());
          if (upper_slot != null) {
            upper_layer.subdivideSlot(upper_slot, brick.getMinX(), brick.getMaxX(), min_brick_width);
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

  public void draw() {
    // draw outline
    //stroke(200);
    //noFill();
    //line(tl.x, tl.y, tr.x, tr.y);
    //line(tl.x, tl.y, bl.x, bl.y);
    //line(bl.x, bl.y, br.x, br.y);
    //line(tr.x, tr.y, br.x, br.y);

    // draw layers;
    noStroke();
    fill(100, 100, 220);
    for (Layer l : layers) {
      l.draw(2);
    }

    // draw bricks
    stroke(200, 150);
    //fill(200, 150, 150, 100);
    fill(random(100, 200), random(100, 200));
    for (Brick b : bricks) {
      b.draw(false);
    }
    
    // draw holes
    //noStroke();
    //fill(200, 100);
    //for (Rectangle hole : holes) {
    //  hole.draw();
    //}
  }
}