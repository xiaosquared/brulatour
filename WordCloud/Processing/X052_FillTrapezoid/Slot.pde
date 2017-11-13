class Slot {
  float left;
  float right;
  float distance;

  public Slot(float left, float right) {
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

  public void draw(float y, float h) {
    rect(left, y, distance, h);
  }

  public boolean contains(float val) {
    return val >= left && val <= right;
  }
  
  //public boolean containsBrick(float brick_position, float brick_width) {
  //  return contains(brick_position + 2) ||
  //         contains(brick_position + brick_width/2) || 
  //         contains(brick_position + brick_width -2);
  //}
}