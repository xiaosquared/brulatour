class House {
  
  // right now, it's just a holder and manager for stories and roof
  // each story or the roof takes care of its own absolute x, y
  // This is a shitty way of doing it... but I just want to solve the problem of
  // filling across stories
  
  float base_x;
  float base_y;
  float width;
  float layer_thickness;
  
  int num_windows;
  
  ArrayList<Story> stories;
  Roof roof;
  int current_story_index = 0;
  
  PVector trans = new PVector(0, 0);
  
  public House(float base_x, float base_y, float width, int num_windows, float layer_thickness) {
    this.base_x = base_x;
    this.base_y = base_y;
    this.width = width;
    this.layer_thickness = layer_thickness;
    
    this.num_windows = num_windows;
    stories = new ArrayList<Story>();
  }
  
  void setTranslation(float x, float y) {
    trans.x = x;
    trans.y = y;
  }
  
  void translateX(float amount) {
    trans.x += amount;
  }
  
  void translateY(float amount) {
    trans.y += amount;
  }
  
  float buildingHeight() {
    float h = 0;
    for (Story s : stories) {
      h += s.getHeight();
    }
    return h;
  }
  
  // the ratios are optimal for a 3 dinwos house
  void addStory(int hue, int window_hue) {
    
    float story_height = .40 * width;
    Story story = new Story(base_x, base_y - buildingHeight() - story_height, width, story_height, layer_thickness, hue);
    
    float top_margin = 0.15 * story.height;
    float bot_margin = 0.15 * story.height;
    float side_margin = .13 * story.width;
    float in_between = 0.13 * story.width;
    float gap = layer_thickness;
    
    story.addWindows(num_windows, top_margin, bot_margin, side_margin, in_between, gap, window_hue);
    
    stories.add(story);
  }
  
  void addBalconyStory(int wall_hue, int railing_hue, int window_hue) {
    float story_height = .45 * width;
    Story story = new Story(base_x, base_y - buildingHeight() - story_height, width, story_height, layer_thickness, wall_hue);
    
    float rail_width = max(layer_thickness * 2, width * .02);
    float between_rails = max(layer_thickness, width * .01);
    story.addRailing(rail_width, between_rails, rail_width, railing_hue);
    
    float top_margin = 0.15 * story.height;
    float bot_margin = 0;
    float side_margin = .13 * story.width;
    float in_between = 0.18 * story.width;
    float gap = layer_thickness;
    
    story.addWindows(num_windows, top_margin, bot_margin, side_margin, in_between, gap, window_hue);
    
    stories.add(story);
  }
  
  void addArchStory(int hue, int window_hue) {
    float story_height = .45 * width;
    Story story = new Story(base_x, base_y - buildingHeight() - story_height, width, story_height, layer_thickness, hue);
    
    float top_margin = 0.15 * story.height;
    float bot_margin = 0;
    float side_margin = .13 * story.width;
    float in_between = 0.1 * story.width;
    float gap = layer_thickness;
    
    story.addArchWindows(num_windows, top_margin, bot_margin, side_margin, in_between, gap, window_hue);
    
    stories.add(story);
  }
  
  void addStory(Story s) {
    stories.add(s);
  }
  
  void addTriangularRoof(boolean has_overhang, int hue) {
    float roof_height = 0.32 * width;
    float overhang = 0;
    if (has_overhang)
      overhang = 0.05 * width;

    roof = new Roof(base_x - overhang, base_y - buildingHeight() - roof_height, width + overhang*2, roof_height,
                     layer_thickness, hue);
  }
  
  void addRoof(boolean has_overhang, float angle, int hue) {
    float roof_height = 0.32 * width;
    float overhang = 0;
    if (has_overhang)
      overhang = 0.05 * width;

    roof = new Roof(base_x - overhang, base_y - buildingHeight() - roof_height, width + overhang*2, roof_height, angle,
                     layer_thickness, hue);
  }
  
  void setRoof(Roof roof) {
    this.roof = roof;
  }
  
  void fillAll() {
    if (roof != null) {
      roof.fillAll();
    }
    for (Story story : stories) {
      story.fillAll();
    }
  }
  
  boolean isFilled() {
    if (roof != null && !roof.isFilled) {
      return false;
    } 
    for (Story s : stories) {
      if (!s.isFilled())
        return false;
    }
    return true;
  }
  
  void fillByLayer() {
    if (current_story_index == -1 && !roof.isFilled) {
      roof.addWord();
      roof.checkLayer();
    }
    if (stories.size() > 0 && current_story_index >= 0) {
      Story cs = stories.get(current_story_index);
      cs.fillByLayer();
      if (cs.isFilled()) {
        current_story_index ++;
        if (current_story_index == stories.size())
          current_story_index = -1;
      }
    }
  }
  
  void reset() {
    if (roof != null) {
      roof.reset();
    }
    for (Story story: stories) {
      story.reset();
    }
    current_story_index = 0;
  }
  
  void draw(boolean outline, boolean layers, boolean words) {
    pushMatrix();
    translate(trans.x, trans.y);
    
    if (roof!= null) { 
      roof.draw(outline, layers, words);
    }
    for (Story story : stories) {
      story.draw(outline, layers, words);
    }
    popMatrix();
  }
  
  void draw() {
    draw(false, false, true);
  }
}