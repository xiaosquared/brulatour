import java.util.Random;

public class NoteGroup {
  Note[] notes;
  float width;
  float in_between;
  float start_x;
  boolean staffAbove = false; // stemUp

  PVector connector_start = new PVector(0, 0);

  float MIN_BETWEEN = 60;

  public NoteGroup(float width, float start_x) {
    this.width = width;
    this.start_x = start_x;
    int how_many_notes = ceil(width / MIN_BETWEEN);
    in_between = width / (float) how_many_notes;

    notes = new Note[how_many_notes+1];
    NoteName name = NoteName.getRandomNote();
    
    boolean up = (random(1) > 0.5);
    for (int i = 0; i <= how_many_notes; i++) {
      NoteName next_name;
      if (up) {
        next_name = name.nextNoteUp();
      } else {
        next_name = name.nextNoteDown();
      }
      if (next_name == null) {
        up = !up;
        if (up) {
          next_name = name.nextNoteUp();
        } else {
          next_name = name.nextNoteDown();
        }
      }
      
      Note n = new Note(next_name, in_between * i + start_x);
      notes[i] = n;
      name = next_name;
    }
  }

  public PVector connectorStart() { 
    return connector_start;
  }

  // returns the angle between the first and last notes
  public float getFirstLastAngle() {
    if (notes.length < 2)
      return 0;
    int last = notes.length-1;
    float x = notes[last].position().x - notes[0].position().x;
    float y = notes[last].position().y - notes[0].position().y;
    return atan2(y, x);
  }

  public void update() {
    for (int i = 0; i < notes.length; i++) {
      notes[i].update();
    }
  }

  public void draw(SineStaff staff, boolean draw_connector, boolean draw_stems, float opacity) {
    fill(255, opacity);
    float max_y = 0;
    float min_y = height;
    int direction_count = 0;

    boolean[] notes_drawn = new boolean[notes.length];
    for (int i = 0; i < notes.length; i++) {
      notes_drawn[i] = notes[i].draw(staff, -1, notes.length == 1 ? true : false, opacity);
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

    float end_y = max_y+60;

    if (direction_count < 0 ) { //|| (direction_count == 0 && random(2) <= 1)) {
      end_y = min_y - 60;
      start_r = -start_r;
      end_r = -end_r;
      staffAbove = true;
    } 

    PVector start = new PVector(start_x-start_r, end_y);
    connector_start = start;
    PVector end = new PVector(end_x-end_r, end_y);
    if (draw_connector)
      line(start.x, start.y, end.x, end.y);

    if (!draw_stems)
      return;
    // draw stem lines to connecting line
    for (int i = 0; i < notes.length; i++) {
      if (!notes_drawn[i]) 
        return;
      PVector note_position = notes[i].position();
      float note_r = notes[i].diameter/2;
      if (start_r < 0) note_r = -note_r;
      float x = note_position.x-note_r;
      float y = evaluateLine(start, end, x);
      //line(x, note_position.y, x, y);
      drawTextStems(x, note_position.y, y, staffAbove, 'x');
    }
  }

  private void drawTextStems(float x, float start_y, float end_y, boolean staff_above, char letter) {
    textSize(6);
  
    float stem_len = abs(start_y - end_y);
    float letter_width = textWidth(letter);
    float filled_len = letter_width + 20; //staff_above ? letter_width : letter_width + 20;
    pushMatrix();
    translate(x, start_y);
    rotate(-PI/2);

    while (filled_len < stem_len) {
      text(letter, staff_above? filled_len : -filled_len + 20, 0);
      filled_len += letter_width;
    }
    popMatrix();
  }

  // find y of line between p1 & P2 at x
  private float evaluateLine(PVector p1, PVector p2, float x) {
    float m = (p2.y - p1.y)/(p2.x - p1.x);
    return m * (x - p1.x) + p1.y;
  }
}