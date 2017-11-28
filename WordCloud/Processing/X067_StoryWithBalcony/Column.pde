class Column extends Wall {
  
  public Column(float x, float y, float width, float height, float layer_thickness, int hue) {
    super(x, y, width, height, hue);
    
    this.hue = hue;
    this.layer_thickness = layer_thickness;
    layers = new ArrayList<Layer>();
    int num_layers = floor(width/layer_thickness);
    for (int i = 0; i < num_layers; i++) {
      float layer_x = x + i * layer_thickness;
      layers.add(new Layer(y, y+height, layer_x, layer_thickness, true));
    }
  }

 
}