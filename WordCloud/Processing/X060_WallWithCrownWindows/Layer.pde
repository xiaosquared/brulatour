class Layer {
  float lower_bound;
  float upper_bound;
  float position;
  float thickness; 
  float length;
  
  ArrayList<Slot> slots;
  
  public Layer(float lower_bound, float upper_bound, float position, float thickness) {
    this.lower_bound = min(lower_bound, upper_bound);
    this.upper_bound = max(lower_bound, upper_bound);
    this.position = position;
    this.thickness = thickness;
    this.length = upper_bound - lower_bound;
  
    slots = new ArrayList<Slot>();
    slots.add(new Slot(lower_bound, upper_bound));
  }
  
  public boolean isFilled() {
    return slots.isEmpty();
  }
  
  public float getLowerBound() {
    return lower_bound;
  }
  
  public float getUpperBOund() {
    return upper_bound;
  }
  
  public Slot getSlot(float left_bound, float right_bound) {
    for (Slot s : slots) {
      
      if (s.contains(left_bound) && s.contains(right_bound)) { 
        return s;
      }
    }
    return null;
  }
  
  public boolean overlapsVertically(Layer other) {
    return (this.position < other.position && this.position + thickness > other.position)
           || (this.position < other.position+thickness && this.position + thickness > other.position+thickness);
  }
  
  public Slot getOverlappingSlot(float left_bound, float right_bound) {
    for (Slot s : slots) {
      
      // this makes sure that the edge bricks don't grow too tall
      if (s.contains(left_bound) || s.contains(right_bound)) { 
        return s;
      }
    }
    return null;
  }
  
  public Brick addWordBrick(Word word, float brick_width, float min_brick_width, float brick_height) {
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
        brick = new Brick(brick_position, position - brick_height, brick_width, brick_height, word);
    
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
  
  public void extendTo(float new_bound) {
    lower_bound = min(new_bound, lower_bound);
    upper_bound = max(new_bound, upper_bound);
    length = upper_bound - lower_bound;
    
    slots = new ArrayList<Slot>();
    slots.add(new Slot(lower_bound, upper_bound));
  }
  
  public void extendLowerBy(float amount) {
    lower_bound -= amount;
    length = upper_bound - lower_bound;
    
    slots = new ArrayList<Slot>();
    slots.add(new Slot(lower_bound, upper_bound));
  }
  
  public void extendUpperBy(float amount) {
    upper_bound += amount;
    length = upper_bound - lower_bound;
    
    slots = new ArrayList<Slot>();
    slots.add(new Slot(lower_bound, upper_bound));
  }
  
  // by default draws a horizontal layer
  public void draw() {
    //stroke(200);
    //noFill();
    //rect(lower_bound, position-thickness, length, thickness);
    
    // drawing slot
    noStroke();
    fill(100, 100, 200);
    
    for (Slot s : slots) {
      s.draw(position, 2);
    }
  }
}

class LayerVertical extends Layer {
  public LayerVertical(float lower_bound, float upper_bound, float position, float thickness) {
    super(lower_bound, upper_bound, position, thickness);
    
    slots = new ArrayList<Slot>();
    slots.add(new SlotVertical(lower_bound, upper_bound));
  }
  
  public void draw() {
    stroke(200);
    noFill();
    rect(position, lower_bound, thickness, length);
    
    // drawing slot
    noStroke();
    fill(100, 100, 200);
    for (Slot s: slots) {
      s.draw(position, 2);
    }
  }
}