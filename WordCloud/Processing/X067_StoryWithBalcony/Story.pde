class Story {
  Wall base;
  Wall main;
  ArrayList<Wall> windows;
  Railing railing;
  
  float layer_thickness;
  int layer_index = 0;
  float gap;
  
  public Story(float x, float y, float width, float height, float layer_thickness, int hue) {
    main = new Wall(x, y, width, height, layer_thickness, hue);
    windows = new ArrayList<Wall>();
    this.layer_thickness = layer_thickness;
  }
  
  void reset() {
    main.reset();
    
    if (base != null)
      base.reset();
    
    if (railing != null)
      railing.reset();
    
    for (Wall win : windows) {
      win.reset();
      main.addHole(win.tl, win.br, gap);
    }
  }
  
  // TODO: The height ratio is such a hack right now!!!
  
  void addRailing(float rail_width, float in_between, float top_rail_height, int hue) {
   
    float railing_top_y = main.tl.y + main.height * 0.6;
    railing = new Railing(new PVector(main.tl.x, railing_top_y),
                          new PVector(main.width, main.height * 0.4),
                          rail_width, in_between, top_rail_height, layer_thickness, hue);
                          
    shortenWall(railing_top_y);                      
  }
  
  void addWindows(int num, float top_margin, float bot_margin, float side_margin, float in_between, float gap, int hue) {
    this.gap = gap;
    
    float win_width = (main.width - 2 * side_margin - (num-1) * in_between)/num;  
    float win_height = main.height - top_margin - bot_margin;
    
    // create the windows
    float win_y = main.tl.y + top_margin;
    for (int i = 0; i < num; i++) {
      float win_x = main.tl.x + side_margin + i * (in_between + win_width);
      Wall win = new Wall(win_x, win_y, win_width, win_height, layer_thickness, hue);
      windows.add(win);
    }
    
    if (bot_margin > 0)
      splitWall(win_y + win_height + gap);
    
    // create holes in main wall
    for (Wall win : windows) {
      main.addHole(win.tl, win.br, gap);
    }
  }
  
  void addArchWindows(int num, float top_margin, float bot_margin, float side_margin, float in_between, float gap, int hue) {
    this.gap = gap;
    
    float win_width = (main.width - 2 * side_margin - (num-1) * in_between)/num;  
    float win_height = main.height - top_margin - bot_margin;
    
    //println(win_width + ", " + win_height);
    
    // create the windows
    float win_y = main.tl.y + top_margin;
    for (int i = 0; i < num; i++) {
      PVector w_tl = new PVector(main.tl.x + side_margin + i * (in_between + win_width), 
                                win_y);
      PVector w_br = new PVector(w_tl.x + win_width, win_y + win_height);              
      ArchWindow w = new ArchWindow(w_tl, w_br, layer_thickness, hue);
      windows.add(w);
    }
    splitWall(win_y + win_height + gap);
    
    // create holes in main wall
    int index = 0;
    Layer current_wall_layer = main.layers.get(index);
    Layer current_window_layer;
    while(current_wall_layer.position > main.br.y) {
      index++;
      current_wall_layer = main.layers.get(index);
    }
    
    println(index);
    
    // since wall and window layers are the same thickness, we will just increment both
    int num_gap_layers = ceil(gap/layer_thickness);
    
    for (Wall w : windows) {
      
      // this is for the bottom gap
      current_window_layer = w.layers.get(0);
      for (int i = 0; i < num_gap_layers; i++) {
        if (index - i < 0)
          break;
        current_wall_layer = main.layers.get(index - i);
        if (current_wall_layer != null) {
          main.divideWall(current_wall_layer, current_window_layer.lower_bound, 
                          current_window_layer.upper_bound, gap);
        }
      }
      
      // this is for the top gap. the 1.2 is a total hack to increase the top gap
      
      for (int i = w.layers.size() -1 ; i > num_gap_layers; i--) {
        current_window_layer = w.layers.get(i);
        if (index + num_gap_layers + i >= main.layers.size())
          break;
        current_wall_layer = main.layers.get(ceil(index + num_gap_layers * 1.2 + i));  
        if (current_wall_layer != null) {
          main.divideWall(current_wall_layer, current_window_layer.lower_bound, 
                          current_window_layer.upper_bound, gap);
        }
      }

      // this is for the main area of the window
      for (int i = 0; i < w.layers.size(); i++) {
        current_window_layer = w.layers.get(i);
        current_wall_layer = main.layers.get(index + i);
      
        main.divideWall(current_wall_layer, current_window_layer.lower_bound, 
                          current_window_layer.upper_bound, gap);
      }
    }
    
  }
   
  void splitWall(float y) {
    shortenWall(y);
    
    float new_height_base = main.br.y - y;
    if (new_height_base > layer_thickness)
      base = new Wall(main.tl.x, y, main.width, new_height_base, layer_thickness, main.hue);
  }
  
  void shortenWall(float y) {
    float new_height_main = y - main.tl.y;
    main = new Wall(main.tl.x, main.tl.y, main.width, new_height_main, layer_thickness, main.hue);
  }
  
  // TODO: Add railing stuff... ALSO UP DATE THE CODE...
  void fillByLayer() {
    
    if (base != null && !base.isFilled) {
      base.fillByLayer();
    }
    else if (railing != null && !railing.isFilled()) {
      railing.fillByLayer();  
    }
    else {
      Word word;
      boolean main_full = main.currentLayerFull(); 
      if (!main_full) {
        word = wm.getRandomWord();
        main.addWord();
      }
    
      boolean win_full = true;
      for (Wall win : windows) {
        boolean cur_win_full = win.currentLayerFull();
        win_full = win_full && cur_win_full;
        if (!cur_win_full) {
          word = wm.getRandomWord();
          win.addWord();
        }
      }
    
      if (main_full && win_full) {
        main.advanceLayerIndex();
        for (Wall win : windows)
          win.advanceLayerIndex();
      }
    }
  }
  
  void fillAll() {
    main.fillAll();
  
    if (railing != null)
      railing.fillAll();
    
    if (base != null)
      base.fillAll();
    
    for (Wall win : windows)
      win.fillAll();
  }
  
  boolean isFilled() {
    if (!main.isFilled)
      return false;
    for (Wall win : windows) {
      if (!win.isFilled)
        return false;
    }
    return true;
  }
  
  void draw(boolean outline, boolean layers, boolean words) {
    
    main.draw(outline, layers, words);
    
    if (base != null) 
      base.draw(outline, layers, words);
    
    if (railing != null) {
      railing.draw(outline, layers, words);
    }
    
    for (Wall win : windows) {
      win.draw(outline, layers, words);
    }
  }
}