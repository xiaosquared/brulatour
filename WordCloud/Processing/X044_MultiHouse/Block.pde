class Block {
  
  House[] houses = new House[3];
  
  float scale = 0.5;
  PVector origin = new PVector(0, 200);
  
  Block() {
    String file1 = "bourbon1-words.json";
    String file2 = "bourbon2-words.json";
    String file3 = "bourbon3-words.json";
    
    houses[0] = new House(file1, ws, new PVector(95, 220), 1309);
    houses[1] = new House(file2, ws, new PVector(240, 220), 1026);
    houses[2] = new House(file3, ws, new PVector(434, 220), 633);
  }
  
  void draw() {
    pushMatrix();
    translate(origin.x, origin.y);
    for (int i = 0; i < houses.length; i++) {
      houses[i].draw(0, 0, scale);
      translate(houses[i].width * scale, 0);
    }
    popMatrix();
  }
}