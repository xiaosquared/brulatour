// 12.21.17
//
// Block Division
//
// Testing the algorithm for dividing up a block
//


float unit_width = 30;
float unit_height = 20;
float total_size;
float y = 600;
int count;

void setup() {
  size(1280, 800);
  stroke(255);
  noFill();
  
  total_size = width - 200;
  count = drawGrid(unit_width, total_size);
}

void draw() {
  
}

int drawGrid(float unit_width, float total_size) {
  int count = 0;
  background(0);
  float start = getStart(total_size);
  for (int x = 0; x < total_size; x+=unit_width) {
    rect(start + x, y, unit_width, 10);
    count ++;
  }
  return count;
}

ArrayList<Integer> divideBlock(int units) {
  ArrayList<Integer> divisions = new ArrayList<Integer>();
  
  while (units > 1) {    
    int toRemove = floor(random(2, 5));
    if (toRemove > units)
      return divisions;
    
    divisions.add(new Integer(toRemove));
    units -= toRemove;
  }
  return divisions;
}

void printBlock(ArrayList<Integer> divisions) {
  for (Integer i : divisions) {
    println(i.toString());
  }
}

int sum(ArrayList<Integer> divisions) {
  int count = 0;
  for (Integer i : divisions) {
    count += i.intValue();
  }
  return count;
}

float getStart(float total_size) {
  return ((float)width - total_size)/2;
}

void drawBuildings(ArrayList<Integer> divisions) {
  float x = getStart(sum(divisions) * unit_width);
  for(Integer myInteger : divisions) {
    int i = myInteger.intValue();
    float width = i * unit_width;
    float height = unit_height * floor(random(2, 5));
    rect(x, y - height, width, height);
    x += width;
  }
}

void keyPressed() {
  background(0);
  drawGrid(unit_width, total_size);
  ArrayList<Integer> divisions = divideBlock(count-2);
  drawBuildings(divisions);
}