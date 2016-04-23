// 4.23.16
// Rain Test
//
// Users Pixi to render words as "rain" falling into a house

var stats = new Stats();
stats.showPanel(0);
document.body.appendChild(stats.dom);

var renderer, stage;

var wordClusters;
var wordsJSON;

var ctr;

function preload() {
  wordsJSON = loadJSON("assets/bourbon2-words.json");
}

function setup() {
  wordSet.init();
  initPixi();

  ctr = new function() {
    this.randomness = 0.5;
    this.acceleration = 0.1;
  }
  var gui = new dat.GUI();
  gui.add(ctr, 'randomness', 0, 1).onFinishChange(function(val) {
    doToAllWords(function(word) {
      var random = Math.random() * val;
      word.p_start.y = (word.p_start.y - 800) * 10 * random;
    });
  });
  gui.add(ctr, 'acceleration', 0.01, 2).onFinishChange(function(val) {
    doToAllWords(function(word) {
      word.a.y = val;
    })
  });

  wordClusters = parseJSON(wordsJSON, doToWord);
  function doToWord(word) {
    word.translate(-100, -200);
    word.setDestination(word.p_start.x, word.p_start.y);
    word.p_start.y = (word.p_start.y - 800) * 10 * Math.random();
    word.text.y = word.p_start.y;
    word.a.y = 0.1;
  }
}

function draw() {
  stats.begin();

  for (var i = 0; i < wordClusters.length; i++) {
    wordClusters[i].update();
  }

  renderer.render(stage);
  stats.end();
}

window.addEventListener('keydown', function(e) {
  console.log("key pressed: " + e.keyCode);
  switch(e.keyCode) {
    case 32:
      for (var i = 0; i < wordClusters.length; i++) {
        wordClusters[i].reset();
      }
    break;
  }
});

//////////////////////
// HELPER FUNCTIONS //
//////////////////////

function initPixi() {
  renderer = PIXI.autoDetectRenderer(1280, 800, {backgroundColor: 0x111111});
  document.body.appendChild(renderer.view);
  renderer.view.style.position = 'absolute';
  renderer.view.style.left = '50%';
  renderer.view.style.top = '50%';
  renderer.view.style.transform = 'translate3d( -50%, -50%, 0 )';

  stage = new PIXI.Container();
}

function doToAllWords(f) {
  for (var i = 0; i < wordClusters.length;i++) {
    var wc = wordClusters[i];
    for (var j = 0; j < wc.words.length; j++) {
      var word = wc.words[j];
      f(word);

    }
  }
}
