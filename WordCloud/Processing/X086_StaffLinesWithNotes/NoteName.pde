import java.util.Random;

public enum NoteName { 
  E, F, G, A, B, C2, D2, E2, F2, G2; 

  public static NoteName getRandomNote() {
    Random random = new Random();
    return values()[random.nextInt(values().length)];
  }
  
  public int whichLine() {
    switch(this) {
      case E: case F:
        return 0;
      case G: case A:
        return 1;
      case B: case C2:
        return 2;
      case D2: case E2:
        return 3;
      case F2: case G2:
        return 4;  
      default:
        return 0;
    }
  }
  
  public boolean isOnLine() {
    switch(this) {
      case E: case G: case B: case D2: case F2:
        return false;
      default:
        return true;
     }
  }
  
  public int stemDirection() {
    switch(this) {
      case E: case F: case G: case A:
        return -1;
      case C2: case D2: case E2: case F2: case G2:
        return 1;
      case B: default: 
        return 0;
    }
  }
}