// 2.14.16
//
// An experiment of drawing text at different sizes  
// seeing how text size relates to rectangle around it
// Quote by Rainer Maria Rilke

String phrase = "Let everything happen to you\nBeauty and Terror\njust keep going\nno feeling is final.";
String[] words;

PFont font;
float padding_below = 5;
float min_height = 15;
float max_height = 30;

float init_y = 50;
float word_y = init_y;

int counter = 0;
int change_count = 125;

void setup() {
  size(600, 600);
  background(50);
  
  font = createFont("American Typewriter", 40);
  textFont(font);
  textAlign(LEFT, TOP);  

  words = splitTokens(phrase);
}

void draw() {
  if (counter % change_count == 0) {
    counter = 0;
    drawWords();
  }
  else
    fade();
    
  counter++;
}

void fade() {
  noStroke();
  fill(50, counter/10);
  rect(0, 0, width, height);
}

void drawWords() {
  word_y = init_y;
  for (int i = 0; i < words.length; i++) {
    String word = words[i];
   
    // pick a random height and x for each word
    float word_height = random(min_height, max_height);
    textSize(word_height);
    float word_width = textWidth(word);
    float word_x = random(50, width - (word_width*1.5));
    
    // draw the word and box around it
    stroke(200); fill(200); 
    text(word, word_x, word_y);
    stroke(200, 50); noFill();
    rect(word_x, word_y, word_width, word_height * 1.25);
    
    // increment the y based on what was drawn
    word_y += (word_height * 1.25) + padding_below;
  }
}