// 1.14.18
//
// Descending Wave
//
// It's a bug that it keeps on descending, but it's kind of beautiful
//

ArrayList<SineTerm> sine_terms;
int num_terms;

float r = 3;
float trans_x = 0;
float trans_y = 0;
float x_offset = 5;
float y_offset = 40;

float taper_width;

void setup() {
  size(1200, 800);
  background(30);
 
  taper_width = width/2;
 
  noStroke();
  fill(180);
  resetSines();
  drawStaff();
}

void draw() {
  trans_x++;
  drawStaff();
}

void resetSines() {
  sine_terms = new ArrayList<SineTerm>();
  for (int i = 0; i < 5; i++) {
    SineTerm st = new SineTerm(random(0.8, 1.2), random(20, 80), random(0, TAU));
    sine_terms.add(st);
  }
}

void drawStaff() {
  background(0);
  pushMatrix();
  
  // I don't know why but if I reverse the order of the translate & rotate
  // the issue with the descend goes away
  
  translate(trans_x, trans_y);
  rotate(-PI/20);
  
  float y = 0;
  for (float x = -trans_x; x < width - trans_x + 100; x+=5) {
        
    float taper = 1;
    if ((x+trans_x) < taper_width)
      taper = (x+trans_x)/taper_width; 
    
    for (SineTerm st : sine_terms) {
      y += st.evaluate(x/TAU);
    }
    ellipse(x + x_offset, y - y_offset * taper, r, r);
    ellipse(x + 2 * x_offset, y - (2 * y_offset)*taper, r, r);
    ellipse(x + 3 * x_offset, y - (3 * y_offset)*taper, r, r);
    ellipse(x + 4 * x_offset, y - (4 * y_offset)*taper, r, r);
    ellipse(x + 5 * x_offset, y - (5 * y_offset)*taper, r, r);
    
  }
  popMatrix();
}

void mousePressed() {
}

void keyPressed() {
  resetSines();
}