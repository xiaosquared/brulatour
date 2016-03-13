var font;

function preload() {
  font = loadFont('assets/american-typewriter.ttf');
}

function setup() {
  createCanvas(1500, 1000);
  fill(200);
  textFont(font);
  textSize(20);
  text("Hello World.", 50, 50);
}

function draw() {
  background(50);
  text("Hello World", 50, 50);
}
