// a key-value pair where key is int and value is float
class IValue {
  int i;
  float val;
 
  IValue(int i, float val) {
    this.i = i;
    this.val = val;
  }
  
  void printInfo() {
    println("i: " + i + " val: " + val);
  }
}

// constraints in each of the four cardinal directions
class Constraints {
  IValue north;
  IValue south;
  IValue east;
  IValue west;
  
  Constraints() {
    north = new IValue(-1, 0);
    south = new IValue(-1, 0);
    east = new IValue(-1, 0);
    west = new IValue(-1, 0);
  }
  
  IValue getMinEW() {
    float min_val = min(abs(east.val), abs(west.val));
    if (min_val == abs(east.val))
      return east;
    else 
      return west;
  }
  
  IValue getMinNS() {
    float min_val = min(abs(north.val), abs(south.val));
    if (min_val == abs(north.val))
      return north;
    else 
      return south;
  }
  
  int getMinDirection() {
    float min_val_NS = min(abs(north.val), abs(south.val));
    float min_val_EW = min(abs(east.val), abs(west.val));
    float min_overall = min(min_val_NS, min_val_EW);
    
    if (min_overall == abs(north.val))
      return 1;
    if (min_overall == abs(south.val))
      return 2;
    if (min_overall == abs(east.val))
      return 3;
    else
      return 4;
  }
  
  IValue getValue(int dir) {
    if (dir == 1)
      return north;
    if (dir == 2)
      return south;
    if (dir == 3)
      return east;
    if (dir == 4)
      return west;
    return null;
  }
  
  void printInfo() {
    println("east-- i: " + east.i + " val: " + east.val);
    println("west-- i: " + west.i + " val: " + west.val);
    println("south-- i " + south.i + " val: " + south.val);
    println("north-- i " + north.i + " val: " + north.val);
  }
}