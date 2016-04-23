// 4.19.16
// Uses Pixi to render words

var wordSet = (function() {
  var ws = {};
  ws.words = [];
  ws.widths = [];
  ws.ratios = [];
  ws.defaultFontSize = 20;
  ws.numWords = 0;

  ws.getWord = function(i) {
    return ws.words[i];
  }

  ws.init = function() {
    ws.initWords();
    ws.computeWidths();
  }

  ws.initWords = function() {
    ws.words[0] = "Vieux carré";
    ws.words[1] = "Mardi Gras";
    ws.words[2] = "Mississippi River";
    ws.words[3] = "Lake Pontchartrain";
    ws.words[4] = "War of 1812";
    ws.words[5] = "St. Louis Cathedral";
    ws.words[6] = "sugar";
    ws.words[7] = "plantation";
    ws.words[8] = "Congo Square";
    ws.words[9] = "bamboula";
    ws.words[10] = "Treme";
    ws.words[11] = "Marigny";
    ws.words[12] = "levee";
    ws.words[13] = "Storyville";
    ws.words[14] = "Louis Armstrong";
    ws.words[15] = "Jelly-Roll Morton";
    ws.words[16] = "Creole";
    ws.words[17] = "Bayou St. John";
    ws.words[18] = "Jean Lafitte";
    ws.words[19] = "French Market";
    ws.words[20] = "Uptown";
    ws.words[21] = "hurricane";
    ws.words[22] = "slavery";
    ws.words[23] = "Reconstruction";
    ws.words[24] = "antibellum";
    ws.numWords = 25;
  }

  ws.computeWidths = function() {
    textSize(20);
    for (var i = 0; i < ws.numWords; i++) {
       ws.widths[i] = textWidth(ws.words[i]);
       ws.ratios[i] = ws.widths[i]/ws.defaultFontSize;
    }
  }

  return ws;
})();

function Word(i, x, y, h, c) {
  this.i = i;
  this.fontSize = h;

  var myFont = h+"px "+"American Typewriter";
  var color = '#fff';
  if (c == 20) {
    color = '#555';
  }
  else if (c == 100) {
    color = '#aaa';
  }

  this.text = new PIXI.Text(wordSet.getWord(i), {font: myFont, fill:color});
  this.text.x = x; this.text.y = y;

  this.p_start = {x: this.text.x, y: this.text.y};
  this.p_end = {x: this.text.x, y: this.text.y};
  this.v = {x: 0, y: 0};
  this.a = {x: 0, y: 0};

  this.translate = function(x, y) {
    this.text.x += x; this.text.y += y;
    this.p_start.x = this.text.x; this.p_start.y = this.text.y;
  }

  this.setVelocity = function(x, y) {
    this.v.x = x; this.v.y = y;
  }

  this.setDestination = function(x, y) {
    this.p_end.x = x; this.p_end.y = y;
  }

  this.update = function() {
    if (this.text.y > this.p_end.y) {
      this.v.y = 0;
      this.text.y = this.p_end.y;
      return;
    }
    this.v.x += this.a.x; this.v.y += this.a.y;
    this.text.x += this.v.x; this.text.y += this.v.y;
  }

  this.reset = function() {
    this.text.x = this.p_start.x;
    this.text.y = this.p_start.y;
    this.v.x = 0;
    this.v.y = 0;
  }

  this.print = function() {
    console.log("Word at " + x + ", " + y);
  }

  this.makeFontString = function(size, font) {
    return size+"px "+font;
  }
}

function WordCluster() {
  this.words = [];

  this.update = function() {
    for (var i = 0; i < this.words.length; i++) {
      this.words[i].update();
    }
  }

  this.addWord = function(w) {
    this.words.push(w);
  }

  this.reset = function() {
    for (var i = 0; i < this.words.length; i++) {
      this.words[i].reset();
    }
  }

  this.clearWords = function() {
    this.words = [];
  }
}
