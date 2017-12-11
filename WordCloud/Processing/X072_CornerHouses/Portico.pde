class Portico implements Fillable {
  ArrayList<Panel> panels;
  ArrayList<Column> columns;
  
  boolean right_edge = false;
  boolean left_edge = false;
  
  
  // TODO!! The constructors repeat themselves... can be combined
  
  public Portico(float x, float y, float width, float height, int num, float col_width, float layer_thickness, int wall_hue, int col_hue) {
    panels = new ArrayList<Panel>();
    
    float panel_width = (width - (col_width * (num+1))) / num;
    for (int i = 0; i < num; i++) {
      float wall_x = col_width + i * (col_width + panel_width);
      Panel panel = new Panel(x + wall_x, y, panel_width - layer_thickness, height, layer_thickness, wall_hue);
      panels.add(panel);
    }
    
    columns = new ArrayList<Column>();
    for (int i = 0; i < num+1; i++) {
      float col_x = i * (col_width + panel_width);
      
      float col_height_addition = num == 1 ? height / 8 : 0; 
      Column col = new Column(x + col_x, y - col_height_addition, col_width, height + col_height_addition, layer_thickness, col_hue); 
      columns.add(col);
    }
  }
  
  public Portico(float x, float y, float width, float height, int num, float col_width, float layer_thickness, boolean right, int wall_hue, int col_hue) {
    panels = new ArrayList<Panel>();
    
    float panel_width = (width - (col_width * (num+1))) / num;
    
    int start = 0;
    int end = num;
    
    // if left side is shorter, make the shorter wall
    if (!right) {
      start = 1;
      Panel panel = new Panel(x + (col_width*2 + panel_width)/2, y, panel_width/2 - layer_thickness, height, layer_thickness, wall_hue);
      panels.add(panel);
      left_edge = true;
    }
    else {
      end--;
      right_edge = true;
    }
    
    // make all the middle walls
    for (int i = start; i < end; i++) {
      float wall_x = col_width + i * (col_width + panel_width);
      Panel panel = new Panel(x + wall_x, y, panel_width - layer_thickness, height, layer_thickness, wall_hue);
      panels.add(panel);
    }
    
    // if right side is shorter, make the right side shorter wall
    if (right) {
      float wall_x = col_width + end * (col_width + panel_width);
      Panel panel = new Panel(x + wall_x, y, panel_width/2 - layer_thickness, height, layer_thickness, wall_hue);
      panels.add(panel);
    }
    
    columns = new ArrayList<Column>();
    for (int i = 0; i < num+1; i++) {
      float col_x = i * (col_width + panel_width);
      
      float col_height_addition = num == 1 ? height / 8 : 0; 
      Column col = new Column(x + col_x, y - col_height_addition, col_width, height + col_height_addition, layer_thickness, col_hue); 
      columns.add(col);
    }
  }
  
  void addRailing(float rail_width, float in_between, float top_rail_height, int hue) {
    int start = 0;
    int end = panels.size();
    
    if (left_edge) {
      start++;
      panels.get(0).addRailingSides(rail_width, in_between, top_rail_height, panels.get(0).width, 0, hue);
    }
    if (right_edge) {
      end--;
      panels.get(panels.size()-1).addRailingSides(rail_width, in_between, top_rail_height, 0, panels.get(panels.size()-1).width, hue);
    }
    
    for (int i = start; i < end; i++) {
      panels.get(i).addRailing(rail_width, in_between, top_rail_height, hue);
    }
  }
  
  void addRailingTo(int i, float rail_width, float in_between, float top_rail_height, int hue) {
    panels.get(i).addRailing(rail_width, in_between, top_rail_height, hue);
  }
  
  void addWindows(float top_margin, float bot_margin, float side_margin, float gap, int hue) {
    int start = 0;
    int end = panels.size();
    
    if (left_edge)
      start++;
    if (right_edge)
      end--;
    for (int i = start; i < end; i++) {
      panels.get(i).addWindow(top_margin, bot_margin, side_margin, gap, hue);
    }
  }
  
  void addWindowTo(int i, float top_margin, float bot_margin, float side_margin, float gap, int hue) { 
    panels.get(i).addWindow(top_margin, bot_margin, side_margin, gap, hue);
  }
    
  void addArchWindows(float top_margin, float bot_margin, float side_margin, float gap, int hue) {
    int start = 0;
    int end = panels.size();
    
    if (left_edge)
      start++;
    if (right_edge)
      end--;
    
    for (int i = start; i < end; i++) {
      panels.get(i).addArchWindow(top_margin, bot_margin, side_margin, gap, hue);
    }
  }
  
  void addArchWindowTo(int i, float top_margin, float bot_margin, float side_margin, float gap, int hue) {
    panels.get(i).addArchWindow(top_margin, bot_margin, side_margin, gap, hue);
  }
  
  void reset() {
    for (Panel p : panels) {
      p.reset();
    }
    for (Column c : columns) {
      c.reset();
    }
  }
  
  void fillAll() {
    for (Panel p : panels) {
      p.fillAll();
    }
    for (Column c : columns) {
      c.fillAll();
    }
  }
  
  void fillByLayer() {
    for (Panel p : panels) {
      p.fillByLayer();
    }
    for (Column c : columns) {
      c.fillByLayer();
    }
  }
  
  boolean isFilled() {
    for (Column c : columns) {
       if (! c.isFilled)
         return false;
    }
    for (Panel p : panels) {
      if (! p.isFilled())
        return false;
    }
    return true;
  }
  
  void draw() {
    for (Panel p : panels) {
      p.draw();
    }
    for (Column c : columns) {
      c.draw();
    }
  }
  
  void draw(boolean outline, boolean layers, boolean words) {
    for (Panel p : panels) {
      p.draw(outline, layers, words);
    }
    for (Column c : columns) {
      c.draw(outline, layers, words);
    }
  }
}