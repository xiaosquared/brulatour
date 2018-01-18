// 1.14.18
// 
// Image into Bars
//
// Take a black and white image, creates horizontal bars 
// Fill it with words
//

PImage img;
float unit = 2;

float tx = 80;
float ty = 325;

ArrayList<Layer> layers;

String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCarondolet Canal\nsugar\ntobacco\ncotton\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\ncypress\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nDowntown\nhurricane\nslavery\nReconstruction\nantibellum";
PFont font;
int default_font_size = 20;
WordManager wm;

Wall w;

void setup() {
  size(600, 600);
  textAlign(LEFT, TOP);
  colorMode(HSB, 360, 100, 100);
  fill(250);
  
  img = loadImage("pianist.gif");
  background(0);
  image(img, tx, 50);
  
  font = createFont("American Typewriter", 60);
  textFont(font, default_font_size);
  wm = new WordManager();
  wm.addAllWords(phrase);
  
  layers = imgToLayers(img, unit);
  translate(tx, ty);
 
  w = new Wall(layers, unit, 100);
  w.fillAll();
  w.draw();
}

ArrayList<Layer> imgToLayers(PImage img, float unit) {
  layers = new ArrayList<Layer>();
  
  for (int y = img.height-1; y >= 0; y -= unit) {
   
    ArrayList<Slot> slots = new ArrayList<Slot>();
 
    boolean isPrevBlack = false;   
    Slot s = null;
    
    for (int x = 0; x < img.width; x+= unit) {
      
      color c = img.pixels[y * img.width + x];
      boolean isBlack = isBlack(c); 
     
      if (x + unit >= img.width && s != null) {
        slots.add(new Slot(s.getLeft(), s.getRight()));  
      }
     
      if (isBlack) {
        if (s == null) 
          s = new Slot(x, x + unit);
        else 
          s.setRight(x + unit);
      } 
      else if (isPrevBlack) {
        if (s != null) {
          slots.add(new Slot(s.getLeft(), s.getRight()));
          s = null;
        }
      }
      isPrevBlack = isBlack;
    }
    
    if (slots.size() > 0) {
      layers.add(new Layer(slots, y, unit));
    }
  }
  
  return layers;
}


boolean isBlack(color c) {
  return red(c) == 0;
}

void draw() {}

void keyPressed() {
  background(0);
  image(img, tx, 50);
  
  translate(tx, ty);
  layers = imgToLayers(img, unit);
  w = new Wall(layers, unit, 100);
  
  w.fillAll();
  w.draw();
}