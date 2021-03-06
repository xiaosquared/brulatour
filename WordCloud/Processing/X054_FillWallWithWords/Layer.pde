class Layer {
  ArrayList<Slot> slots;
  float left_boundary;
  float right_boundary;
  float y;
  float layer_height;
  
  public Layer(float left, float right, float y, float layer_height) {
    Slot initial = new Slot(left, right);
    slots = new ArrayList<Slot>();
    slots.add(initial);
    
    left_boundary = left;
    right_boundary = right;
    this.y = y;
    this.layer_height = layer_height;
  }
  
  public boolean isFilled() {
    return slots.isEmpty();
  }
  
  public float getLeftBoundary() {
    return left_boundary;
  }
  
  public float getRightBoundary() {
    return right_boundary;
  }
  
  public Slot getSlot(float left_bound, float right_bound) {
    for (Slot s : slots) {
      
      // this makes sure that the edge bricks don't grow too tall
      if (s.contains(left_bound) && s.contains(right_bound)) { 
        return s;
      }
    }
    return null;
  }
  
  public Brick addWordBrick(Word word, float brick_width, float min_brick_width) {
    if (slots.isEmpty()) {
      return null;
    }

    Brick brick;
    for (int i = 0; i < slots.size(); i++) {
      Slot current_slot = slots.get(i);
      float slot_size = current_slot.getDistance();
      
      if (slot_size < min_brick_width || current_slot.failure_count > 3) {
        slots.remove(current_slot);
      }
      else if (slot_size >= brick_width) {
        float brick_position = random(current_slot.getLeft(), current_slot.getRight() - brick_width);
        brick = new Brick(brick_position, y-layer_height, brick_width, layer_height, word);
    
        subdivideSlot(current_slot, brick_position, brick_position + brick_width, min_brick_width);
        return brick;
      } 
      else {
        current_slot.failure_count++;
      }
    }
    return null; 
  }
  
  
  
 
  public void subdivideSlot(Slot current_slot, 
                            float brick_left, float brick_right, float min_brick_width) {
    
    if (brick_left - current_slot.getLeft() > min_brick_width) {
      slots.add(new Slot(current_slot.getLeft(), brick_left));
    }
    if (current_slot.getRight() - brick_right > min_brick_width) {
      slots.add(new Slot(brick_right, current_slot.getRight()));
    }
    slots.remove(current_slot);
  }
 
  public void draw(float h) {
    if (isFilled()) {
       ellipse(left_boundary,  y, h, h);
       ellipse(left_boundary,  y, h, h);
    }
    for (Slot s : slots) {
      s.draw(y, h);    
    }
  }
}