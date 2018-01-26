class SineStaff {
  ArrayList<SineWave> lines;
  int main_line_id = 2;
  float taper_width = 300;
  float y_space;

  float min_taper = 0;
  float angle = 0;

  ArrayList<Note> notes;
  LinkedList<WordNote> word_notes;

  float word_start_x = 0;
  float word_end_x = width;

  TrebleClef clef;
  
  boolean addNotes = true;

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
    word_notes = new LinkedList<WordNote>();
    
    clef = new TrebleClef(taper_width/2, lines.get(1).positions[(int)taper_width/2].y);
  }
  
  public float getWidth() { 
    return lines.get(main_line_id).getWidth();
  }
  public float getMaxX() { 
    return lines.get(main_line_id).getMaxX();
  }

  public void clearWordNotes() { 
    word_notes.clear();
    word_start_x = taper_width;
    word_end_x = width;
    println(word_notes.size());
  }

  public void removeFirstWordNote() {
    word_notes.remove();
    if (word_notes.size() == 0) {
      word_start_x = taper_width;
      word_end_x = width;
    }
  }

  public PVector getPosition(int i, int x) {
    return lines.get(i).positions[x];
  }

  public int getNumPositions() {
    return lines.get(2).positions.length;
  }

  public void fadeNotes() {
    for (WordNote wn : word_notes) {
      wn.fade();
    }
  }

  public void fillWithWordNotes(float start_x, float font_size) {
    String word = getRandomWord();
    textSize(font_size);
    float word_width = textWidth(word);

    while (start_x + word_width < getMaxX()) {
      WordNote wn = new WordNote(word, font_size, start_x);
      word_notes.add(wn);
      start_x += word_width + font_size*3;

      word = getRandomWord();
      textSize(font_size);
      word_width = textWidth(word);
    }
    word_start_x = start_x;
    word_end_x = start_x;
  }

  public boolean addWordNote(float font_size) {
      String word = getRandomWord();
      textSize(font_size);
      float word_width = textWidth(word);
      if (word_start_x + word_width >= min(word_end_x, getMaxX())) {
        word_end_x = word_start_x;
        //word_start_x = taper_width;
        return false;
      }
      WordNote wn = new WordNote(word, font_size, word_start_x);
      word_notes.add(wn);
      word_start_x += word_width + font_size*3;
      return true;
  }

  public void addWordNote(WordNote wn) {
    word_notes.add(wn);
  }

  Note addRandomNote() {
    NoteName which = NoteName.getRandomNote();
    //println(which);
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
    clef.update();
    
    for (Note n : notes) 
      n.update();

    boolean toClear = true;
    for (WordNote wn : word_notes) {
      wn.update();
      if (wn.opacity > 15)
        toClear = false;
    }
    if (toClear) { clearWordNotes(); }
    

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
    
    clef.setOriginY(lines.get(1).positions[(int)taper_width/2].y);
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
    
    clef.draw();
    popMatrix();

    popMatrix();
  }
}