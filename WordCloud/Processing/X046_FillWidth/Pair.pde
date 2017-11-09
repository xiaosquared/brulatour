class Pair {
  float left;
  float right;
  
  public Pair(float left, float right) {
    this.left = left;
    this.right = right;
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
    return right - left;
  }
}