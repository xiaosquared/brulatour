class House {
  PImage img;
  int x;
  int y;
  
  House (String path, int x, int y) {
    img = loadImage(path);
    this.x = x;
    this.y = y;
  }
  
  int getWidth() {
    return img.width;
  }
  
  void move(int amount) {
    x += amount;
    //if (x < -img.width) {
    //  x = width;
    //} if (x > width) {
    //  x = -img.width;
    //}
  }
  
  void draw() {
    image(img, x, y);
  }
}