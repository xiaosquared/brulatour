class Wall {
  ArrayList<Bar> bars;
  float bar_height = 15; 
  ArrayList<Rectangle> bricks;
  
  float x, y;
  float wall_height;
 
  int current_bar_index;
  boolean filled = false;
  
  public Wall(float x, float y, float wall_width, float wall_height, float bar_height) {
    this.x = x;
    this.y = y;
    this.bar_height = bar_height;
    this.wall_height = wall_height;
    
    bars = new ArrayList<Bar>();
    bricks = new ArrayList<Rectangle>();
    
    int num_bars = floor(wall_height/bar_height);
    for (int i = 0; i < num_bars; i++) {
      bars.add(new Bar(0, wall_width));
    }
  }
  
  public boolean isFilled() {
    return filled;
  }
  
  public void addBrick(float min_brick_width, float max_brick_width) {
    if (filled) {
      return;
    }
    
    // decide on height of rectangle
    // if we are at the top bar, all rectangles must be small
    
    float brick_height_multiplier = 1;
    if (random(4) > 3.2) {
      brick_height_multiplier = floor(random(1, min(4, bars.size() - current_bar_index)));
    }
    float brick_height = bar_height * brick_height_multiplier;
    float brick_y = wall_height - (current_bar_index * bar_height) - brick_height;
    
    
        
    Bar current_bar = bars.get(current_bar_index);
    Rectangle brick = current_bar.addBrick(min_brick_width, max_brick_width, 
                                                      brick_y, brick_height, bricks);
    

    if (brick != null  && brick_height_multiplier > 1) {
      for (int i = 0; i < brick_height_multiplier; i++) {
        Bar upper_bar = bars.get(current_bar_index + i);
        Pair upper_bar_interval = upper_bar.getInterval(brick.getMinX()+1); // ugh, the +1 is such a hack
        if (upper_bar_interval != null) {
          upper_bar.subdivide(upper_bar_interval, brick.getMinX(), brick.width);       
        }
      }
    }                                                      
                                                      
    if (current_bar.isFilled()) {
      current_bar_index ++;
      if (current_bar_index == bars.size()) {
        filled = true;
      }
    }
  }
  
  public void drawBars() {
    noStroke();
    fill(100);
    
    pushMatrix();
    translate(x, y);
    for (int i = 0; i < bars.size(); i++) {
      float y = wall_height - (i * bar_height);
      bars.get(i).draw(y, 2);
    }
    popMatrix();
  }
  
  public void drawBricks() {
    stroke(250);
    fill(200, 150, 150, 100);
    
    pushMatrix();
    translate(x, y);
    for (Rectangle brick : bricks) {
      brick.draw();  
    }
    popMatrix();
  }
}

class Bar {
  ArrayList<Pair> intervals;
  
  float min_gap_size = 3;      //TODO: There's probably a better place to keep this information...
  float max_gap_size = 8;
  
  
  public Bar(float left, float right) {
    Pair initial_bounds = new Pair(left, right);
    intervals = new ArrayList<Pair>();
    intervals.add(initial_bounds);
  }
  
  public boolean isFilled() {
    return intervals.isEmpty();
  }
  
  // Returns true if the bar is completely full, false if there is still room
  public Rectangle addBrick(float min_brick_width, float max_brick_width, 
                          float brick_y, float brick_height, ArrayList<Rectangle> bricks) {
                            
    Pair current_interval = intervals.get(0);
    
    // if the interval is too small, remove it. 
    if (current_interval.getDistance() < min_brick_width) {
       intervals.remove(current_interval);
       //return(intervals.isEmpty());
       return null;
    }
    
    // if space only fits one rectangle
    Rectangle brick;
    float gap = random(min_gap_size, max_gap_size);
      
    if (current_interval.getDistance() <= max_brick_width) {
      brick = new Rectangle(current_interval.getLeft() + gap, brick_y, current_interval.getDistance() - 2*gap, brick_height);
      bricks.add(brick);
      intervals.remove(current_interval);
      return brick;
    }
    // if space fits more than one rectangle, put one in and divide the space
    else {
      float position = random(current_interval.getLeft(), current_interval.getRight() - max_brick_width);
      float brick_width = random(min_brick_width, max_brick_width);
      brick = new Rectangle(position, brick_y, brick_width, brick_height);
      bricks.add(brick);
      subdivide(current_interval, position, brick_width);
    }
    return brick;
  }
  
  private Pair getInterval(float position) {
    for (Pair p : intervals) {
      if (p.contains(position))
        return p;
    }
    return null;
  }
  
  private void subdivide(Pair interval, float block_position, float block_width) {
    float gap = random(min_gap_size, max_gap_size);
    
    intervals.add(new Pair(interval.getLeft(), block_position - gap));
    intervals.add(new Pair(block_position + block_width + gap, interval.getRight()));
    intervals.remove(interval);
  }
  
  public void remove(Pair interval) {
    intervals.remove(interval);
  }
  
  public void draw(float y, float h) {
    for (Pair p : intervals) {
      rect(p.getLeft(), y, p.getDistance(), h); 
    }
  }
}

class Pair {
  float left;
  float right;
  float distance;
  
  public Pair(float left, float right) {
    this.left = min(left, right);
    this.right = max(left, right);
    distance = this.right - this.left;
  }
  
  public float getLeft() {
    return left;
  }
  
  public float getRight() {
    return right;
  }
  
  public void setLeft(float val) {
    left = val;
  }
  
  public void setRight(float val) {
    right = val;
  }
  
  public float getDistance() {
    return distance;
  }
  
  public boolean contains(float val) {
    return val > left && val < right;
  }
}