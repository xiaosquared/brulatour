class Panel extends Story implements Fillable {
  
  public Panel(float x, float y, float width, float height, float layer_thickness, int hue) {
    super(x, y, width, height, layer_thickness, hue);  
  }
  
  void addWindow(float top_margin, float bot_margin, float side_margin, float gap, int hue) {
    super.addWindows(1, top_margin, bot_margin, side_margin, 0, gap, hue);
  }
  
  void addArchWindow(float top_margin, float bot_margin, float side_margin, float gap, int hue) {
    super.addArchWindows(1, top_margin, bot_margin, side_margin, 0, gap, hue);
  }
  
  void reset() {
    super.reset();
  }
  
  void fillAll() {
    super.fillAll();
  }
  
  void fillByLayer() {
    super.fillByLayer();
  }
  
  boolean isFilled() {
    return super.isFilled();
  }
  
  void draw() {
    super.draw();
  }
  
  void draw(boolean outline, boolean layers, boolean words) {
    super.draw(outline, layers, words);
  }
 
}