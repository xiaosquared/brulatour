class Story {
  Wall base;
  Wall main;
  ArrayList<Wall> windows;
  
  float layer_thickness;
  int layer_index = 0;
  float gap;
  
  boolean draw_outline = false;
  boolean draw_layers = false;
  boolean draw_words = true;
  
  public Story(float x, float y, float width, float height, float layer_thickness, int hue) {
    main = new Wall(x, y, width, height, layer_thickness, hue);
    windows = new ArrayList<Wall>();
    this.layer_thickness = layer_thickness;
  }
  
  void reset() {
    main.reset();
    if (base != null)
      base.reset();
    
    for (Wall win : windows) {
      win.reset();
      main.addHole(win.tl, win.br, gap);
    }
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
    
    splitWall(win_y + win_height + gap);
    
    // create holes in main wall
    for (Wall win : windows) {
      main.addHole(win.tl, win.br, gap);
    }
  }
  
  void splitWall(float y) {
    float new_height_main = y - main.tl.y;
    float new_height_base = main.br.y - y;
    
    main = new Wall(main.tl.x, main.tl.y, main.width, new_height_main, layer_thickness, main.hue);
    base = new Wall(main.tl.x, y, main.width, new_height_base, layer_thickness, main.hue);
  }
  
  
  void fillByLayer() {
    
    if (!base.isFilled) {
      word = wm.getRandomWord();
      addWord(word, base);
      checkLayer(base);
    }
    else {
      boolean main_full = main.currentLayerFull(); 
      if (!main_full) {
        word = wm.getRandomWord();
        addWord(word, main);
      }
    
      boolean win_full = true;
      for (Wall win : windows) {
        boolean cur_win_full = win.currentLayerFull();
        win_full = win_full && cur_win_full;
        if (!cur_win_full) {
          word = wm.getRandomWord();
          addWord(word, win);
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
    while (!main.isFilled) {
      word = wm.getRandomWord();
      addWord(word, main);
      checkLayer(main);
    }
    
    while (!base.isFilled) {
      word = wm.getRandomWord();
      addWord(word, base);
      checkLayer(base);
    }
    
    for (Wall win : windows) {
      while (!win.isFilled) {
        word = wm.getRandomWord();
        addWord(word, win);
        checkLayer(win);
      }
    }
  }
  
  void addWord(Word word, Wall wall) {
    if (!wall.addWordBrick(word, true))
      wall.addWordBrick(wm.getRandomWord(), false);
  }
  
  void checkLayer(Wall wall) {
    if (wall.currentLayerFull()) {
       wall.advanceLayerIndex(); 
    }  
  }
  
  void draw() {
    
    main.draw(draw_outline, draw_layers, draw_words);
    
    if (base != null) 
      base.draw(draw_outline, draw_layers, draw_words);
    
    for (Wall win : windows) {
      win.draw(draw_outline, draw_layers, draw_words);
    }
  }
}