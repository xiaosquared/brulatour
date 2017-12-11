class Railing {
  PVector tl;
  PVector br;
  
  float width;
  float height;
  
  ArrayList<Column> rails;
  Wall top_rail;
  Wall bottom_rail;
  int current_rail = 0;
  
  // tb_rail_height is thickness of top & bottom horizontal rails
  public Railing(PVector tl, PVector dim, float rail_width, float in_between, float tb_rail_height, float layer_thickness, int hue) {
    this.tl = tl;
    this.width = dim.x;
    this.height = dim.y;
    this.br = new PVector(tl.x + dim.x, tl.y + dim.y);
    
    // find how many rails, round down
    float err = rail_width % layer_thickness;
    int num_rails = floor((width + err - rail_width) / (rail_width + in_between)) + 1;
    
    // adjust in between distance for rounded number of rails
    in_between = (width + err - (rail_width * num_rails)) / (num_rails - 1);

    
    rails = new ArrayList<Column>();
    for (int i = 0; i < num_rails; i++) {
      Column rail = new Column(tl.x + i * (rail_width + in_between), 
                                tl.y + tb_rail_height, rail_width, height - 2*tb_rail_height, layer_thickness, hue);
      rails.add(rail);                          
    }
    
    top_rail = new Wall(tl.x, tl.y, width, tb_rail_height, layer_thickness, hue);
    bottom_rail = new Wall(tl.x, tl.y+height - tb_rail_height, width, tb_rail_height, layer_thickness, hue);
  }
  
  void reset() {
    for (Column rail : rails)
      rail.reset();
    top_rail.reset();
    bottom_rail.reset();
    current_rail = 0;
  }
  
  void fillAll() {
    bottom_rail.fillAll();
    for (Column rail : rails) {
      rail.fillAll();
    }
    top_rail.fillAll();
  }
  
  void fillByLayer() {
    if (!bottom_rail.isFilled) {
      bottom_rail.fillByLayer();
    }
    
    else if (verticalFilled() && !top_rail.isFilled) {
      top_rail.fillByLayer();
    }
    else {
      Column my_rail = rails.get(current_rail);
      if (!my_rail.isFilled) {
        my_rail.fillByLayer();
      } else {
        if (current_rail <= rails.size()) {  
          current_rail++;
        }
      }
    }
  }
  
  boolean isFilled() {
    if (top_rail.isFilled)
      return true;
    else return false;
  }
  
  boolean verticalFilled() {
    if (rails.get(rails.size()-1).isFilled)
      return true;
    else return false;
  }
  
  void draw(boolean outline, boolean layers, boolean words) {
    for (Column rail : rails) {
      rail.draw(outline, layers, words);
    }
    top_rail.draw(outline, layers, words);
    bottom_rail.draw(outline, layers, words);
  }
  
  void draw() {
    for (Column rail : rails) {
      rail.draw();
    }
    
    top_rail.draw();
  }
}