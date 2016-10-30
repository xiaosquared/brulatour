class ScrollingBlock {
  LinkedList<House> houses;
  
  String[] houseTemplates;
  
  ScrollingBlock() {
    houses = new LinkedList<House>();
    add(new House("house1.png", 0, 200));
    add(new House("house2.png", 0, 200));
    add(new House("house3.png", 0, 200));
    add(new House("house1.png", 0, 200));
    
    houseTemplates = new String[3];
    houseTemplates[0] = "house1.png";
    houseTemplates[1] = "house2.png";
    houseTemplates[2] = "house3.png";
  }
  
  void add(House h) {
    if (houses.size() > 0) {
      House last = houses.getLast();
      h.x = last.x + last.getWidth() - 5;
      println("x " + h.x);
    }
    houses.addLast(h);
  }
  
  void remove() {
    houses.remove();
  }
  
  void scrollLeft(int amount) {
    for (House h : houses) {
      h.move(-amount);
    }
    
    // if left-most house is not visible, remove it
    House first = houses.getFirst();
    if (first.x + first.getWidth() < 0) {
      houses.remove();
    }
    
    // if empty space at the end, add new one 
    House last = houses.getLast();
    if (last.x + last.getWidth() < width) {
      add(createRandomHouse());
    }
  }
  
  
  void scrollRight(int amount) {
    for (House h : houses) {
      h.move(amount);
    }
  }
  
  void update() {
    scrollLeft(1);
  }
  
  void draw() {
    for (House h : houses) {
      h.draw();
    }
  }
  
  House createRandomHouse() {
    int index = floor(random(2.9));
    println(index);
    House h = new House(houseTemplates[index], 0, 200);
    return h;
  }
}