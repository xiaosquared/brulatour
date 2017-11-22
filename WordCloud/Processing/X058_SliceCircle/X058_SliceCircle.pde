// 11.16.17
//
// Slice Ellipse
//
// Turning a curved shape into layers.. in order to make holes for the walls
// Do it for both vertical and horizontal slices!
//
// Layer is a simplified version of the class used in the past few sketches 
//

float d = 500;
float layer_height = 25;
float min_width = 10;
ArrayList<Layer> layers_h = new ArrayList<Layer>();
ArrayList<Layer> layers_v = new ArrayList<Layer>();

void setup() {
  size(1200, 600);

  noFill();
  stroke(200);
  
  layers_h = sliceSemiCircleHorizontal(300, 300, d/2, layer_height, min_width);
  layers_v = sliceSemiCircleVertical(900, 300, d/2, layer_height, min_width);
}

void draw() {
  background(30);
  
  noFill();
  stroke(200);
  ellipse(300, 300, d, d);
  line(600, 0, 600, 600);
  ellipse(900, 300, d, d);
  
  for (Layer l : layers_h) {
    l.draw();
  }
  
  for (Layer l : layers_v) {
    l.draw();
  }
  
  
  fill(200);
  ellipse(300, 300, 5, 5);
  ellipse(900, 300, 5, 5);
}

ArrayList<Layer> sliceSemiCircleHorizontal(float center_x, float center_y, float radius, float layer_height, float min_width) {
  ArrayList<Layer> layers = new ArrayList<Layer>();
  int num_layers = floor(radius / layer_height);
  
  for (int i = 1; i <= num_layers; i++) {
    float y = center_y - i * layer_height;
    float val = sqrt(sq(radius) - sq(y-center_y));
    float left = center_x - val;
    float right = center_x + val;
    if (right - left >= min_width) {
      Layer l = new Layer(center_x - val, center_x + val, y, layer_height, false);
      layers.add(l);
    }
  }
  
  return layers;
}

ArrayList<Layer> sliceSemiCircleVertical(float center_x, float center_y, float radius, float layer_size, float min_width) {
  ArrayList<Layer> layers = new ArrayList<Layer>();
  int num_layers = floor(radius / layer_size);
  
  float sliced_width = num_layers * layer_size;
  float start_x = center_x - sliced_width;
  
  float right_bound = center_y;
  
  // left half 
  for (int i = 0; i < num_layers; i++) {
    float x = start_x + i * layer_size;
    float left_bound = center_y - sqrt(sq(radius) - sq(x - center_x));
    
    if (right_bound - left_bound >= min_width) {
      Layer l = new Layer(left_bound, right_bound, x, layer_size, true);
      layers.add(l);
    }
  }
  // right half
  for (int i = 1; i <= num_layers; i++) {
    float x = center_x + i * layer_size;
    float left_bound = center_y - sqrt(sq(radius) - sq(x - center_x));
    if (right_bound - left_bound >= min_width) {
      Layer l = new Layer(left_bound, right_bound, x-layer_size, layer_size, true);
      layers.add(l);
    }
  }
  
  return layers;
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}