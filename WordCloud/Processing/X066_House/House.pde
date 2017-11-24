class House {
  
  // right now, it's just a holder and manager for stories and roof
  // each story or the roof takes care of its own absolute x, y
  // This is a shitty way of doing it... but I just want to solve the problem of
  // filling across stories
  
  float base_x;
  float base_y;
  float width;
  float layer_thickness;
  
  ArrayList<Story> stories;
  Roof roof;
  int current_story_index = 0;
  
  public House(float base_x, float base_y, float width, float layer_thickness) {
    this.base_x = base_x;
    this.base_y = base_y;
    this.width = width;
    this.layer_thickness = layer_thickness;
    
    stories = new ArrayList<Story>();
  }
  
  float buildingHeight() {
    float h = 0;
    for (Story s : stories) {
      h += s.getHeight();
    }
    return h;
  }
  
  void addStory(float story_height, int hue, int window_hue) {
    Story story = new Story(base_x, base_y - buildingHeight() - story_height, width, story_height, layer_thickness, hue);
    story.addWindows(3, 30, 40, 50, 50, 10, window_hue);
    
    stories.add(story);
  }
  
  void addArchStory(float story_height, int hue, int window_hue) {
    Story story = new Story(base_x, base_y - buildingHeight() - story_height, width, story_height, layer_thickness, hue);
    story.addArchWindows(3, 30, 40, 50, 50, 10, window_hue);
    
    stories.add(story);
  }
  
  void addStory(Story s) {
    stories.add(s);
  }
  
  void addRoof(float roof_height, float overhang, int hue) {
    roof = new Roof(base_x - overhang, base_y - buildingHeight() - roof_height, width + overhang*2, roof_height,
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
    if (roof!= null) { 
      roof.draw(outline, layers, words);
    }
    for (Story story : stories) {
      story.draw(outline, layers, words);
    }
  }
  
  void draw() {
    draw(true, true, true);
  }
}