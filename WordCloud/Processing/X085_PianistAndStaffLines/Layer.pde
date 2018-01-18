// ADDED a new constructor that takes arraylist of slots

class Layer {
  float lower_bound;
  float upper_bound;
  float position;
  float thickness; 
  float length;
 
  ArrayList<Slot> slots;
 
  boolean isVertical = false; 
 
  public Layer(float lower_bound, float upper_bound, float position, float thickness, boolean isVertical) {
    this(lower_bound, upper_bound, position, thickness);
    this.isVertical = isVertical;
    
    slots.clear();
    slots.add(new SlotVertical(lower_bound, upper_bound));
  }
 
  public Layer(float lower_bound, float upper_bound, float position, float thickness) {
    this.lower_bound = min(lower_bound, upper_bound);
    this.upper_bound = max(lower_bound, upper_bound);
    this.position = position;
    this.thickness = thickness;
    this.length = upper_bound - lower_bound;
  
    slots = new ArrayList<Slot>();
    slots.add(new Slot(lower_bound, upper_bound));
  }
 
  public Layer(ArrayList<Slot> slots, float position, float thickness) {
    this.slots = slots;
    this.position = position;
    this.thickness = thickness;
    
    lower_bound = slots.get(0).getLeft();
    upper_bound = slots.get(slots.size()-1).getRight();
  }
  
  public void reset() {
    slots.clear();
    if (isVertical)
      slots.add(new SlotVertical(lower_bound, upper_bound));
    else
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
  
  public ArrayList<Slot> getOverlappingSlots(float left_bound, float right_bound) {
    ArrayList<Slot> overlaps = new ArrayList<Slot>();
    for (Slot s : slots) {
      
      // this makes sure that the edge bricks don't grow too tall
      if (s.left <= right_bound && s.right >=left_bound) {
        overlaps.add(s);
      }
    }
    return overlaps;
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
        brick = isVertical ? 
          new BrickVertical(position - brick_height, brick_position, brick_height, brick_width, word)
          : new Brick(brick_position, position - brick_height, brick_width, brick_height, word);
    
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
    //if (current_slot == null)
    //  return;
    if (brick_left - current_slot.getLeft() > min_brick_width) {
      if (current_slot instanceof SlotVertical)
        slots.add(new SlotVertical(current_slot.getLeft(), brick_left));
      else
        slots.add(new Slot(current_slot.getLeft(), brick_left));
    }
    if (current_slot.getRight() - brick_right > min_brick_width) {
      if (current_slot instanceof SlotVertical)
        slots.add(new SlotVertical(brick_right, current_slot.getRight()));
      else 
        slots.add(new Slot(brick_right, current_slot.getRight()));
    }
    slots.remove(current_slot);
  }
  
  //public void extendTo(float new_bound) {
  //  lower_bound = min(new_bound, lower_bound);
  //  upper_bound = max(new_bound, upper_bound);
  //  length = upper_bound - lower_bound;
    
  //  slots = new ArrayList<Slot>();
  //  slots.add(new Slot(lower_bound, upper_bound));
  //}
  
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
    // drawing slot
    for (Slot s : slots) {
      s.draw(position, 2);
    }
  }
}