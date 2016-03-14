var font;
var raindrops = [];
var phrase = "Vieux carré\nMardi Gras\nMississippi River\nLake Pontchartrain\nWar of 1812\nSt. Louis Cathedral\nsugar\nplantation\nCongo Square\nbamboula\nTreme\nMarigny\nlevee\nStoryville\nLouis Armstrong\nJelly-Roll Morton\nCreole\nBayou St. John\nJean Lafitte\nFrench Market\nUptown\nhurricane\nslavery\nReconstruction\nantibellum";
var words;
var start_y = -50;

var controls;

function preload() {
  font = loadFont('assets/american-typewriter.ttf');
}

function setup() {
  createCanvas(1500, 1000);
  fill(250);
  textFont(font);
  textSize(4);

  controls = new function() {
    this.dayLight = 0.3;
    this.rain = false;
  }
  var gui = new dat.GUI();
  gui.add(controls, 'dayLight', 0, 0.7);
  gui.add(controls, 'rain', false);

  words = split(phrase, '\n');
}

function draw() {
  background(controls.dayLight * 255);

  raindrops.map(function(p) {
    p.run();
  });

  raindrops = raindrops.filter(function(p) {
    return p.position.y < height;
  });

  if (controls.rain) {
    var index = ~~random(25);
    var p = new Particle(random(width), start_y, words[index]);
    raindrops.push(p);
  }
}
