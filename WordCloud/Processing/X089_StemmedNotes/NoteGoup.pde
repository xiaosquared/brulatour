public class NoteGroup {
  Note[] notes;
  float width;
  float in_between;
  float start_x;
  boolean stemUp = false;

  float MIN_BETWEEN = 60;

  public NoteGroup(float width, float start_x) {
    this.width = width;
    this.start_x = start_x;
    int how_many_notes = floor(width / MIN_BETWEEN);
    in_between = width / (float) how_many_notes;

    notes = new Note[how_many_notes];
    for (int i = 0; i < how_many_notes; i++) {
      NoteName name = NoteName.getRandomNote();
      println(name);
      Note n = new Note(name, in_between * i + start_x);
      notes[i] = n;
    }
  }

  public void update() {
    for (int i = 0; i < notes.length; i++) {
      notes[i].update();
    }
  }

  public void draw(SineStaff staff) {
    float max_y = 0;
    float min_y = height;
    int direction_count = 0;
    
    boolean[] notes_drawn = new boolean[notes.length];
    for (int i = 0; i < notes.length; i++) {
      notes_drawn[i] = notes[i].draw(staff, -1, notes.length == 1 ? true : false);
      float y = notes[i].position().y;
      max_y = max(max_y, y);
      min_y = min(min_y, y);
      direction_count += notes[i].stemDirection();
    }
    
    if (notes.length == 1)
      return;

    // drawing the connecting line
    float start_x = notes[0].position().x;
    float start_r = notes[0].diameter/2;
    float end_x = notes[notes.length-1].position().x;
    float end_r = notes[notes.length-1].diameter/2;

    float end_y = max_y+40;
    if (staffAbove(direction_count)) {
      end_y = min_y - 40;
      start_r = -start_r;
      end_r = -end_r;
    }
    PVector start = new PVector(start_x-start_r, end_y);
    PVector end = new PVector(end_x-end_r,end_y);
    line(start.x, start.y, end.x, end.y);

      
      // draw stem lines to connecting line
      for (int i = 0; i < notes.length; i++) {
        if (!notes_drawn[i]) 
          return;
        PVector note_position = notes[i].position();
        float note_r = notes[i].diameter/2;
        if (start_r < 0) note_r = -note_r;
        float x = note_position.x-note_r;
        float y = evaluateLine(start, end, x);
        line(x, note_position.y, x, y);
      }
    
  }

  boolean staffAbove(int direction_count) {
    return direction_count > 0;
  }

  // find y of line between p1 & P2 at x
  private float evaluateLine(PVector p1, PVector p2, float x) {
    float m = (p2.y - p1.y)/(p2.x - p1.x);
    return m * (x - p1.x) + p1.y;
  }
}