class SineStaff {
  ArrayList<SineWave> lines;
  int main_line_id = 2;
  float taper_width = 300;
  float y_space;

  float min_taper = 0;
  float angle = 0;

  ArrayList<Note> notes;
  ArrayList<WordNote> word_notes;

  public SineStaff(PVector origin, float width, float height) {
    this(origin, width, height, 0);
  }

  public SineStaff(PVector origin, float width, float height, float angle) {
    this.angle = angle;
    lines = new ArrayList<SineWave>();
    SineWave main_line = new SineWave(origin, width); 

    for (int i = 0; i < 5; i++) {
      if (i != main_line_id) {
        y_space = height / 4; 
        SineWave sw = new SineWave(origin.x, origin.y, width, main_line.getSineTerms());
        lines.add(sw);
      } else 
      lines.add(main_line);
    }
    notes = new ArrayList<Note>();
    word_notes = new ArrayList<WordNote>();
  }

  public PVector getPosition(int i, int x) {
    return lines.get(i).positions[x];
  }

  public int getNumPositions() {
    return lines.get(2).positions.length;
  }

  //public void addNoteGroup(NoteGroup ng) {
    //note_groups.add(ng);
  //}

  public void addWordNote(WordNote wn) {
    word_notes.add(wn);
  }

  Note addRandomNote() {
    NoteName which = NoteName.getRandomNote();
    println(which);
    Note n = new Note(which, 200);
    notes.add(n);
    return n;
  }

  public void initText(String[] words, float font_size) {
    for (SineWave line : lines) {
      line.initText(words, font_size);
    }
    float text_height = font_size *5;
    float total_height = text_height + y_space * 4;
    min_taper = text_height/total_height;
  }

  public void update() {
    for (Note n : notes) 
      n.update();
    
    //for (NoteGroup ng : note_groups) {
    //  ng.update();
    //}
    
    for (WordNote wn : word_notes) {
      wn.update();
    }


    SineWave main = lines.get(main_line_id);
    main.update();
    for (int i = 0; i < 5; i++) {
      if (i != main_line_id) {
        SineWave side_line = lines.get(i);
        for (int pos = 0; pos < main.positions.length; pos++) {

          // taper
          float taper = 1;
          if (pos < taper_width) {
            taper = min_taper + pos/taper_width;
          }
          taper = min(taper, 1);


          float y_offset = ((i - 2) * y_space * taper);
          side_line.positions[pos].y = main.positions[pos].y - y_offset;
        }
      }
    }
  }

  public float getTransY() { 
    return lines.get(2).getTransY();
  }

  public float getLineSpacing(int x) {
    return lines.get(0).positions[x].y - lines.get(1).positions[x].y; 
  }

  public void draw() {
    pushMatrix();
    rotate(angle);
    for (SineWave line : lines) {
      line.draw(taper_width);
    }

    pushMatrix();
    translate(0, getTransY());
    for (Note n : notes) {
      n.draw(this);
    }
    //for (NoteGroup ng : note_groups) {
    //  ng.draw(this);
    //}
    for (WordNote wn : word_notes) {
      wn.draw(this);
    }
    popMatrix();

    popMatrix();
  }
}