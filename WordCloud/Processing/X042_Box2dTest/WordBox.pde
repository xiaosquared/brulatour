class WordBox {
  FBox box;
  String text;
  float font_size;
  
  WordBox(FBox b, String t, float fs) {
    box = b;
    text = t;
    font_size = fs;
  }
  
  void draw() {
    pushMatrix();
    float w = box.getWidth();
    float h = box.getHeight();
    translate(box.getX(), box.getY());
    rotate(box.getRotation());
    noFill();
    //rect(0, 0, w, h);
    textFont(font, font_size);
    text(text, 0, 0);
    popMatrix();
  }
}