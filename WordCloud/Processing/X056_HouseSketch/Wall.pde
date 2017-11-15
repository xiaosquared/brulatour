class Wall extends Rectangle {
  float x, y;
  float layer_height = 15;
  
  ArrayList<Layer> layers;
  int current_layer_index = 0;
  
  public Wall(float x, float y, float width, float height, float layer_height) {
    super(x, y, width, height);
    
    this.layer_height = layer_height;
    
    layers = new ArrayList<Layer>();
    int num_layers = floor(height/layer_height);
    for (int i = 0; i < num_layers; i++) {
      float layer_y = y + height - (i * layer_height);
      layers.add(new Layer(x, x+width, layer_y, layer_height));
    }
    current_layer_index = 0;
  }
  
  void addHole(Rectangle hole) {
    for (Layer layer : layers) {
      if (layer.y > hole.tl.y && layer.y < hole.br.y) {
        Slot slot = layer.getOverlappingSlot(hole.tl.x, hole.br.x);
        if (slot != null) {
          layer.subdivideSlot(slot, hole.tl.x, hole.tr.x, 1);
        }
      }
    }
  }
  
  void draw() {
    drawOutline();
    drawLayers();
  }
  
  void drawOutline() {
    stroke(200);
    noFill();
    super.draw();
  }
  
  void drawLayers() {
    noStroke();
    fill(100, 100, 250);
    for (Layer l : layers) {
      l.draw(2);
    }
  }
}