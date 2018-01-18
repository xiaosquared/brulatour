// 1.14.18
//
// Waving Staff Lines
//
// Staff lines that start from a point and wave around randomly
//

ArrayList<SineTerm> sine_terms;
int num_terms;

float r = 3;
float trans_x = 0;
float trans_y;
float x_offset = 5;
float y_offset = 20;
float y;

float taper_width;

void setup() {
  size(1200, 800);
  background(30);
 
  taper_width = width*0.6;
  trans_y = height/2 + 100;
 
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
  
  rotate(-PI/20);
  translate(trans_x - 20, trans_y);
  
  y = 0;
  for (float x = -trans_x; x < width - trans_x + 100; x+=6) {
    
    float tx = x+trans_x;
    float taper = 1;
    if (tx < taper_width)
      taper = tx/taper_width;
    
    for (SineTerm st : sine_terms) {
      y += st.evaluate(x/TAU);
    }
    
    fill(40 + taper * 180);
    
    ellipse(x + x_offset, y - y_offset * taper, r, r);
    ellipse(x + 2 * x_offset, y - (2 * y_offset)*taper, r, r);
    ellipse(x + 3 * x_offset, y - (3 * y_offset)*taper, r, r);
    ellipse(x + 4 * x_offset, y - (4 * y_offset)*taper, r, r);
    ellipse(x + 5 * x_offset, y - (5 * y_offset)*taper, r, r);
    
  }
  popMatrix();
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}

void keyPressed() {
  resetSines();
}