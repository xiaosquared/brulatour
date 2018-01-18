
// Takes a black and white image
//fills the black parts with words

public class WordImage {

  PVector trans = new PVector(0, 0);
  
  PImage img;
  Wall wall;  
  
  public WordImage(PImage img, float x_unit, float y_unit, int hue) {
      this.img = img;
      wall = new Wall(imgToLayers(img, x_unit, y_unit), hue);
  }
  
  public void setTranslation(float x, float y) {
    trans.x = x; trans.y = y;
  }
  
  public void reset() {
    wall = new Wall(imgToLayers(img, x_unit, y_unit), hue);
  }
  
  ArrayList<Layer> imgToLayers(PImage img, float x_unit, float y_unit) {
    ArrayList<Layer> layers = new ArrayList<Layer>();
      
      for (int y = img.height-1; y >= 0; y -= y_unit ) {
        
        ArrayList<Slot> slots = new ArrayList<Slot>();
        
        // start with a placeholder slot
        Slot s = null;
        boolean isPrevBlack = false;
        
        for (int x = 0; x < img.width; x += x_unit) {
          color c = img.pixels[y * img.width + x];
          boolean isBlack = isBlack(c);
        
          // if we're at the end of the row, create the slot
          if (x + x_unit >= img.width && s != null) {
            slots.add(new Slot(s.getLeft(), s.getRight()));
          }
          
          // otherwise, if the current unit is black
          else if (isBlack) {
            if (s == null)
              s = new Slot(x, x + x_unit);
            else
              s.setRight(x + x_unit);
          }
          
          // if current unit is white, we don't care unless it just transitioned from black
          // then it's time to close the previous slot and start a new placeholder slot
          else if (isPrevBlack) {
            if (s != null) {
              slots.add(new Slot(s.getLeft(), s.getRight()));
              s = null;
            }
          }
          
          isPrevBlack = isBlack;
        }
        
        if (slots.size() > 0) {
          layers.add(new Layer(slots, y, y_unit));
        }
      }
      return layers;
  }
  
  boolean isBlack(color c) {
    return red(c) == 0;
  }
  
  void fillAll() {
    wall.fillAll();
  }

  void draw() {
    pushMatrix();
    translate(trans.x, trans.y);
    wall.draw();
    popMatrix();
  }
}