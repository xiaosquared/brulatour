class Slot {
  float left;
  float right;
  float distance;
  float failure_count = 0; // if it's attempted to be filled and failed
  boolean to_remove;

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

  public void draw(float position, float h, boolean isVertical) {
    if (isVertical) {
      rect(position, left, h, distance);
    }
    else {
      rect(left, position, distance, h);
    }
  }

  public boolean contains(float val) {
    return val >= left && val <= right;
  }
}