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

function Word(i, x, y, w, h, c) {
  this.i = i;
  this.fontSize = h;
  this.x_offset = 100;
  this.y_offset = 200;

  var myFont = h+"px "+"American Typewriter";
  var color = '#fff';
  if (c == 20) {
    color = '#555';
  }
  else if (c == 100) {
    color = '#aaa';
  }
  if (c == 200) {
    color == '#fff';
  }

  this.text = new PIXI.Text(wordSet.getWord(i), {font: myFont, fill:color});
  this.text.x = x-this.x_offset;
  this.text.y = y-this.y_offset;

  this.v = {x: Math.random(-50, 50), y: Math.random(-50, 50)};

  this.update = function() {
    this.text.x = this.text.x + this.v.x;
    this.text.y = this.text.y + this.v.y;
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

  this.clearWords = function() {
    this.words = [];
  }
}
