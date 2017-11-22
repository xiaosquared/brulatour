class Etage {
  Wall wall;
  ArrayList<CrownWindow> windows;
  
  int current_layer_index = 0;
  int num_wall_layers;
  int num_win_layers;
  
  public Etage(Wall wall, ArrayList<CrownWindow> windows) {
    this.wall = wall;
    this.windows = windows;
    num_wall_layers = wall.layers.size();
    num_win_layers = windows.get(0).layers.size();
  }
  
  public void addWord() {
    if (wall.isFilled)
      return;
    
    if (success)
      word = wm.getRandomWord();
    
    for (CrownWindow win : windows) { 
      success = win.addWordBrick(word, true, current_layer_index);
      wall.addWordBrick(wm.getRandomWord(), true, current_layer_index);
    }
  
    if (! success) {
      wall.addWordBrick(wm.getRandomWord(), false, current_layer_index);
      for (CrownWindow win : windows) { 
        win.addWordBrick(word, false, current_layer_index);
      }
    }

    // deal with incrementing layers together
    boolean inc_layer = wall.layers.get(current_layer_index).isFilled();
    if (current_layer_index < num_win_layers) {
      for (CrownWindow win : windows) {
         inc_layer = inc_layer && win.layers.get(current_layer_index).isFilled();
      }
    }
    if (inc_layer)
      current_layer_index++;
      if (current_layer_index == num_wall_layers) {
        wall.isFilled = true;
      }
  }
  
  public void draw() {
    wall.draw();
  
    for (CrownWindow win : windows) {
      win.draw();
    }
  }
}