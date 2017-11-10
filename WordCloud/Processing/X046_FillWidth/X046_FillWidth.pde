// 11.9.17
//
// Fill Width
//
// Starting a new algorithm to make houses from words.
// The previous algorithm was too slow. This one attempts to be faster.
//
// Builds a "brick wall" with blocks between min_rect_width and max_rect_width  
//
//

import org.eclipse.collections.api.list.MutableList;
import org.eclipse.collections.impl.list.mutable.FastList;

MutableList<Pair> all_spaces;
MutableList<Rectangle> rectangles;
int rect_height = 15;
int rect_y;
int min_rect_width = 20;
int max_rect_width = 250;

void setup() {
  size(1200, 800);
  all_spaces = FastList.newListWith(new Pair(100, 1100));
  rectangles = FastList.newList();
  rect_y = height - rect_height;
  background(30);
}

void draw() {
  if (rect_y > -20) {
    buildBrickWall();
    drawRectangles();
    delay(2);
  }
}

void buildBrickWall() {
  if (all_spaces.size() == 0) {
    startNewLine(); 
  } else {
    fillIntervalWithRectangles(all_spaces.get(0), min_rect_width, max_rect_width);
  }
}

void fillIntervalWithRectangles(Pair space, float min_rect_size, float max_rect_size) {
  // if space is too small, don't put anything there
  if (space.getDistance() < min_rect_size) {
    all_spaces.remove(space);
    return;
  }

  // if space only fits one word
  if (space.getDistance() <= max_rect_size) {
    fill(200, 150, 150, 100);
    rectangles.add(new Rectangle(space.getLeft() + random(min_rect_size/6), 
                                rect_y, space.getDistance() - random(min_rect_size/6), rect_height));
    all_spaces.remove(space);
    return;
  }

  // if space fits more than one word, put a word in and divide the space
  float position = random(space.getLeft(), space.getRight() - max_rect_size);
  float rect_width = random(min_rect_size, max_rect_size) - random(5);
  rectangles.add(new Rectangle(position, rect_y, rect_width, rect_height));
  fill(200, 100);

  all_spaces.add(new Pair(space.getLeft(), position - random(min_rect_size/8, min_rect_size/4)));
  all_spaces.add(new Pair(position+rect_width + random(min_rect_size/8, min_rect_size/4), space.getRight()));
  all_spaces.remove(space);
}

public void drawRectangles() {
  stroke(250);
  for (Rectangle r : rectangles) {
    r.draw();
  }
}

void startNewLine() {
  all_spaces = FastList.newListWith(new Pair(100, 1100));
  rectangles = FastList.newList();
  rect_y -= rect_height + 5;
}

void keyPressed() {
}