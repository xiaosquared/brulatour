class Trapezoid {
  ArrayList<Layer> layers;
  float layer_height = 15;
  int current_layer_index = 0;

  PVector tl, tr, bl, br;
  float min_y, max_y;

  ArrayList<Brick> bricks;
  boolean isFilled = false;

  public Trapezoid(PVector tl, PVector tr, PVector bl, PVector br, float layer_height) {
    this.tl = tl;
    this.tr = tr;
    this.bl = bl;
    this.br = br;
    this.layer_height = layer_height;

    min_y = tr.y;
    max_y = br.y;
    
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

  public void addBrick(float min_width, float max_width) {
    if (isFilled) {
      return;
    }
    
    // figure out where on the X-axis to put the brick  
    Layer current_layer = layers.get(current_layer_index);
    Brick brick = current_layer.addBrick(min_width, max_width);
    bricks.add(brick);
    
    // decide if we want to make the brick taller
    float height_scale = 1;
    if (random(4) > 2.5) {
      height_scale = floor(random(1, min(4, layers.size() - current_layer_index)));
    }
    
    // see how much we can grow the brick
    // limit how much the brick grows if it is on the outside edge
    
    if (brick != null && height_scale > 1) {
      int final_height_scale = 1;
      for (int i = 1; i < height_scale; i++) {
        Layer upper_layer = layers.get(current_layer_index + i);
        Slot upper_slot = upper_layer.getSlot(brick.getMinX(), brick.getMaxX());
        if (upper_slot != null) {
          upper_layer.subdivideSlot(upper_slot, brick.getMinX(), brick.getMaxX(), min_width);
          final_height_scale = i+1;
        }
      }
      brick.growHeight(final_height_scale * layer_height);
      
    }
    
    if (current_layer.isFilled()) {
      current_layer_index++;
      if (current_layer_index == layers.size()) {
        isFilled = true;
      }
    }
  }

  public void draw() {
    // draw outline
    stroke(200);
    noFill();
    line(tl.x, tl.y, tr.x, tr.y);
    line(tl.x, tl.y, bl.x, bl.y);
    line(bl.x, bl.y, br.x, br.y);
    line(tr.x, tr.y, br.x, br.y);

    // draw layers;
    noStroke();
    fill(100, 100, 220);
    for (Layer l : layers) {
      l.draw(2);
    }

    // draw bricks
    stroke(200, 150);
    fill(200, 150, 150, 100);
    for (Brick b : bricks) {
      b.draw();
    }
  }
}