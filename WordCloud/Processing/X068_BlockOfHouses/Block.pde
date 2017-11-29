class Block {
  PVector origin;
  ArrayList<House> houses;
  
  Wall sidewalk;
  
  public Block(float x, float y) {
    origin = new PVector(x, y);
    houses = new ArrayList<House>();  
  }
  
  void addHouse(House house) {
    houses.add(house);
  }
  
  void makeSidewalk(float overhang, int hue) {
    float total_width = 0;
    for (House h : houses) {
      total_width += h.width;
    }
    sidewalk = new Wall(origin.x - overhang, origin.y + 10, total_width + 2*overhang, 20, layer_thickness, hue);
  }
  
  float getBaseY() {
    return origin.y;
  }
  
  float getNextX() {
    if (houses.size()== 0)
      return origin.x;
    House last = houses.get(houses.size()-1);
    return last.base_x + last.width;
  }
  
  void reset() {
    if (sidewalk != null)
      sidewalk.reset();
    for (House h : houses)
      h.reset();
  }
  
  void fillAll() {
    for (House h : houses) {
      h.fillAll();
    }
    if (sidewalk != null) {
      sidewalk.fillAll();
    }
  }
  
  void fillByLayer() {
    if (sidewalk != null && !sidewalk.isFilled) {
      sidewalk.fillByLayer();
    }
    else {
      for (House h : houses) {
        h.fillByLayer();
      }
    }
  }
  
  void draw(boolean outline, boolean layers, boolean words) {
    for (House h : houses)
      h.draw(outline, layers, words);
    if (sidewalk != null)
      sidewalk.draw(outline, layers, words);
  }
  
  void draw() {
    draw(false, false, true);
  }
  
}