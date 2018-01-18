// 1.8.18
//
// Words on Bezier
//
// Drag around control points to change the curve
// Press any key to recompute where words are drawn

String phrase = "Hello world ~ ";
PFont font;
int font_size = 20;

PShape bez;
ArrayList<PVector> ac_points;
PVector a1 = new PVector(120, 430);
PVector c1 = new PVector(250, 190);
PVector c2 = new PVector(530, 200);
PVector a2 = new PVector(630, 450);
float radius = 20;
PVector current_point;

double total_length;
float current_length = 0;
int letter_index = 0;

void setup(){
  size(800, 800);
  textAlign(CENTER, CENTER);
  stroke(250);
  noFill();
  
  font = createFont("American Typewriter", font_size);
  textFont(font, font_size);
 
  //make a Bezier curve
  //do it inside a PShape object so we can reference it later
  bez = createShape();
  bez.beginShape();
  bez.vertex(a1.x, a1.y);
  bez.bezierVertex(c1.x, c1.y, c2.x, c2.y, a2.x, a2.y);
  bez.endShape();
 
  // put control points in ArrayList
  ac_points = new ArrayList<PVector>();
  ac_points.add(a1);
  ac_points.add(c1);
  ac_points.add(c2);
  ac_points.add(a2);
 
  // compute the length
  total_length = bezLength(bez, 1000);
}

void draw() {
  background(30);
  drawPoints(ac_points, 15);
  drawBezier();
  drawWordsOnCurve();
}


void drawBezier() {
  bezier(a1.x, a1.y, c1.x, c1.y, c2.x, c2.y, a2.x, a2.y);
}

void drawWordsOnCurve() {
  while (current_length < total_length) {
    char next_letter = phrase.charAt(letter_index);
    float t = current_length / (float) total_length;
    float x = bezierPoint(a1.x, c1.x, c2.x, a2.x, t);
    float y = bezierPoint(a1.y, c1.y, c2.y, a2.y, t);
    float tx = bezierTangent(a1.x, c1.x, c2.x, a2.x, t);
    float ty = bezierTangent(a1.y, c1.y, c2.y, a2.y, t);
    float a = atan2(ty, tx);
   
    pushMatrix();
    translate(x, y);
    rotate(a);
    text(next_letter, 0, 0);
    //line(0, 0, 0, 10);
    popMatrix();
  
    current_length += textWidth(next_letter) + 2;
    letter_index++;
    letter_index %= phrase.length();
  }
  current_length = 0;
  letter_index = 0;
}

PVector getPoint(float x, float y) {
  for (PVector p : ac_points) {
    if (dist(x, y, p.x, p.y) < radius)
      return p;
  }
  return null;
}

void drawPoints(ArrayList<PVector> pts, float r) {
  for (PVector p : pts) {
    ellipse(p.x, p.y, r, r);
  }
}

void redrawWords() {
  bez = createShape();
  bez.beginShape();
  bez.vertex(a1.x, a1.y);
  bez.bezierVertex(c1.x, c1.y, c2.x, c2.y, a2.x, a2.y);
  bez.endShape();
  
  current_length = 0;
  letter_index = 0;
  total_length = bezLength(bez, 1000);
  drawWordsOnCurve();
}

void mousePressed() {
  PVector p = getPoint(mouseX, mouseY);
  if (p != null) {
    current_point = p;
  }
}

void mouseDragged() {
  current_point.x = mouseX;
  current_point.y = mouseY;
}

void keyPressed() {
  redrawWords();
}

////////////////////////////
// LENGTH OF BEZIER CURVE //
//  Code by Chris Reilly  //
////////////////////////////

double bezLength(PShape bez, float error){
  
  double[] myBezLength = new double[1]; //we want this to get passed as a reference so we put it in an array :)
  
  PVector[] bezPts = new PVector[bez.getVertexCount()];
  for( int i=0; i<bez.getVertexCount(); i++){
    bezPts[i] = new PVector( bez.getVertex(i).x, bez.getVertex(i).y );
  }
  
  addIfClose( bezPts, myBezLength,  error );
  
  return myBezLength[0];
}
 
void bezSplit(PVector[] v, PVector[] left, PVector[] right){
  
  ArrayList<PVector[]> vTemp = new ArrayList<PVector[]>();
  for( int g=0; g<4; g++){
    vTemp.add(new PVector[4]); 
    for(int h=0; h<4; h++){
      vTemp.get(g)[h] = new PVector(0, 0);  
    }
  }
  //copy control points
  PVector[] ctrlPts = new PVector[4];
  for( int i=0; i<=3; i++ ){
     ctrlPts[i] = new PVector(v[i].x, v[i].y); 
  }
  vTemp.set(0, ctrlPts );
  
  /* Triangle computation */
  for (int j = 1; j <= 3; j++) {  
    for (int k =0 ; k <= 3 - j; k++) {
        PVector tri = new PVector(  0.5 * vTemp.get(j-1)[k].x + 0.5 * vTemp.get(j-1)[k+1].x, 
                                    0.5 * vTemp.get(j-1)[k].y + 0.5 * vTemp.get(j-1)[k+1].y);
        vTemp.get(j)[k] = tri;   
    }                                      
  }                                       
  
  for (int l = 0; l <= 3; l++){ 
    left[l] = vTemp.get(l)[0];
  }
    
  for (int m = 0; m <= 3; m++){ 
    right[m] = vTemp.get(3-m)[m];
  }
}                                           
 
void addIfClose( PVector[] v, double[] myBezLength, float error){
  
  PVector[] left = new PVector[4], right = new PVector[4];
  double len=0, chord=0;
  
  for (int i=0; i<=2; i++ ){
    len += dist(v[i].x, v[i].y, v[i+1].x, v[i+1].y);    
  }
  
  chord = dist(v[0].x, v[0].y, v[3].x, v[3].y);
  
  if( len-chord > error ){
    bezSplit(v, left, right);
    addIfClose(left, myBezLength, error);
    addIfClose(right, myBezLength, error);
    return;
  }
  
  myBezLength[0] += len;
}