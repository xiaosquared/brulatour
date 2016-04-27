// 4.26.16
//
// Animation reacts to messages sent from a remote client
// uses Socket.io
//
// Draw words in a grid. Do something to the corresponding one when
// remote sends number

var pWidth = 1280;
var pHeight = 720;

var stats = new Stats();
stats.showPanel(0);
document.body.appendChild(stats.dom);


var renderer, stage;

var words = [];
var instructions;

var americanTypewriterFont;
function preload() {
  americanTypewriterFont = loadFont("../assets/american-typewriter.ttf");
}

function setup() {
  textFont(americanTypewriterFont);
  wordSet.init();
  initPixi();

  for (var i = 0; i < wordSet.numWords; i++) {
    // make a word object for every word in the set. put it in random spot on stage
    var w = new Word(i, Math.random() * (pWidth-100), Math.random() * pHeight, 30);

    // adjust if word leaks out of stage right
    if (w.width + w.text.x > pWidth) {
      w.text.x = pWidth - w.width;
    }

    // adds it to the stage and to our array
    stage.addChild(w.text);
    words.push(w);

    // customize things about the word's behavior
    w.setVelocity((Math.random() * 2)-1, (Math.random() * 2) - 1);
    w.update = function() {
      this.text.x += this.v.x;
      this.text.y += this.v.y;
      if (this.text.x < 0) {
        this.v.x = Math.abs(this.v.x);
      } else if (this.text.x + this.width > pWidth) {
        this.v.x = -Math.abs(this.v.x);
      }
      if (this.text.y < 0) {
        this.v.y = Math.abs(this.v.y);
      } else if (this.text.y + this.fontSize > pHeight) {
        this.v.y = -Math.abs(this.v.y);
      }
    }
  }
}

function draw() {
  stats.begin();
  for (var i = 0; i < words.length; i++) {
     words[i].update();
  }
  renderer.render(stage);
  stats.end();
}

// SOCKET.IO
var socket = io();
socket.on('word', function(msg) {
  console.log('word', msg);
  var w = words[msg];

  // a hack for changing the size of the font;
  stage.removeChild(w.text);
  w.setSize(w.fontSize+5);
  stage.addChild(w.text);
});

//////////////////////
// HELPER FUNCTIONS //
//////////////////////

function initPixi() {
  renderer = PIXI.autoDetectRenderer(pWidth, pHeight, {backgroundColor: 0x111111});
  document.body.appendChild(renderer.view);
  renderer.view.style.position = 'absolute';
  renderer.view.style.left = '50%';
  renderer.view.style.top = '50.5%';
  renderer.view.style.transform = 'translate3d( -50%, -50%, 0 )';

  stage = new PIXI.Container();
}
