// 11.24.17
//
// House
//
// Putting stories together into a house! Builds a block of houses
//
// Space bar to reset, Enter to start/stop
//

Roof roof;
House house;
House h2, h3, h4;
float x = 100;
float house_width = 300;
float story_height = 100;
float layer_thickness = 4;


String phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nCarondolet Canal\nsugar\ntobacco\ncotton\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\ncypress\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nDowntown\nhurricane\nslavery\nReconstruction\nantibellum";
PFont font;
int default_font_size = 20;
WordManager wm;
Word word;
boolean success = true;

boolean go = false;

void setup() {
  size(1280, 800);
  stroke(200);
  textAlign(LEFT, TOP);
  colorMode(HSB, 360, 100, 100);
  background(30);
  
  font = createFont("American Typewriter", 60);
  textFont(font, default_font_size);
  
  wm = new WordManager();
  wm.addAllWords(phrase);
  //float min_brick_width = wm.getMinWidth(layer_thickness);
  
  
  float base = height - 100;
  house = new House(x, base, house_width*.8, layer_thickness);
  house.addArchStory(story_height, 50, 100);
  house.addStory(story_height, 50, 100);
  house.addRoof(story_height-50, 20, 280);
  //house.fillAll();
  house.draw(false, false, true);
  
  h2 = new House(x + house.width, base, house_width * 1.2, layer_thickness);
  h2.addStory(story_height*1.5, 80, 220);
  h2.addArchStory(story_height*1.5, 80, 220);
  h2.addStory(story_height*1.5, 80, 200);
  h2.addRoof(story_height/2, 10, 340);
  //h2.fillAll();
  h2.draw(false, false, true);
  
  h3 = new House(x+house.width+h2.width, base, house_width, layer_thickness);
  h3.addStory(story_height, 340, 240);
  h3.addStory(story_height, 340, 240);
  h3.addRoof(story_height, 10, 240);
  //h3.fillAll();
  h3.draw(false, false, true);
  
  h4 = new House(x+house.width+h2.width+h3.width, base, house_width*.6, layer_thickness);
  h4.addStory(story_height, 340, 240);
  h4.addRoof(story_height, 10, 240);
  //h4.fillAll();
  h4.draw(false, false, true);
}

void draw() {
  
  if (!go)
    return;
  
  fillHouse(house);
  fillHouse(h2);
  fillHouse(h3);
  fillHouse(h4);
  
  if (!house.isFilled() || !h2.isFilled() || !h3.isFilled() || !h4.isFilled()) {
      background(30);
      house.draw(false, false, true);
      h2.draw(false, false, true);
      h3.draw(false, false, true);
      h4.draw(false, false, true);
  }
}

void fillHouse(House house) {
  if (!house.isFilled()) {
    house.fillByLayer();
  }
}

void keyPressed() {
  switch(key) {
    case 32:
      background(30);
      house.reset();
      h2.reset();
      h3.reset();
      h4.reset();
      break;
    case 10:
      go = !go;
      break;
  }
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}