// 11.7.17
//
// Fill Width
//
// Starting a new algorithm to make houses from words.
// The previous algorithm was too slow. This one attempts to be faster.
//
// This is the first step. 
//

import org.eclipse.collections.api.list.MutableList;
import org.eclipse.collections.impl.list.mutable.FastList;

MutableList<Pair> all_spaces;
MutableList<Rectangle> rectangles;
int rect_height = 20;
int rect_y = 100;

void setup() {
  size(1200, 800);
  all_spaces = FastList.newListWith(new Pair(100, 1100));
  rectangles = FastList.newList();
  background(30);  
  println("test");
}

void draw() {
  //background(30);
}

void fillIntervalWithRectangles(Pair space, float min_rect_size, float max_rect_size) {

  // if space is too small, don't put anything there
  if (space.getDistance() < min_rect_size) {
    all_spaces.remove(space);
    return;
  }

  // if space only fits one word
  if (space.getDistance() < max_rect_size) {
    fill(200, 150, 150, 100);
    rectangles.add(new Rectangle(space.getLeft(), rect_y, space.getDistance(), rect_height));
    all_spaces.remove(space);
    return;
  }

  // if space fits more than one word, put a word in and divide the space
  float position = random(space.getLeft() + max_rect_size, space.getRight() - max_rect_size);
  float rect_width = random(min_rect_size, max_rect_size);
  rectangles.add(new Rectangle(position, rect_y, rect_width, rect_height));
  fill(200, 100);

  all_spaces.add(new Pair(space.getLeft(), position));
  all_spaces.add(new Pair(position+rect_width, space.getRight()));
  all_spaces.remove(space);
}

//public void drawSpace(Pair space) {
//    fill(220, 160, 220, 100);
//    rect(space.getLeft(), draw_spaces_y_position, space.getRight()-space.getLeft(), 10);
//  }

public void drawRectangles() {
  stroke(250);
  for (Rectangle r : rectangles) {
    r.draw();
  }
}

void startNewLine() {
  all_spaces = FastList.newListWith(new Pair(100, 1100));
  rectangles = FastList.newList();
  rect_y += rect_height + 5;
}

void keyPressed() {
  if (all_spaces.size() == 0) {
    startNewLine(); 
  } else {
    fillIntervalWithRectangles(all_spaces.get(0), 50, 200);
  }
  drawRectangles();
}