// 4.21.16
// Parse Clusters Pixi
//
// Uses Pixi to load word clusters

var stats = new Stats();
stats.showPanel(0);
document.body.appendChild(stats.dom);

var wordsJSON;
var wordClusters;

var renderer, stage;

var bMoveWords;

function preload() {
  wordsJSON = loadJSON("assets/bourbon2-words.json");
}

function setup() {
  renderer = PIXI.autoDetectRenderer(1280, 800, {backgroundColor: 0x111111});
  document.body.appendChild(renderer.view);
  renderer.view.style.position = 'absolute';
  renderer.view.style.left = '50%';
  renderer.view.style.top = '50%';
  renderer.view.style.transform = 'translate3d( -50%, -50%, 0 )';

  stage = new PIXI.Container();

  wordSet.init();
  wordClusters = parseJSON(wordsJSON, doToWord);

  function doToWord(word) {
    word.translate(-100, -200);
    word.setVelocity(Math.random(-50, 50), Math.random(-50, 50));
  }
}

function draw() {
  stats.begin();
  if (bMoveWords)
    moveWords();
  renderer.render(stage);
  stats.end();
}

function moveWords() {
  for (var i = 0; i < wordClusters.length; i++) {
    wordClusters[i].update();
  }
}

window.addEventListener('keydown', function(e) {
  console.log("key pressed: " + e.keyCode);
  switch(e.keyCode) {
    case 32:
      bMoveWords = !bMoveWords;
    break;
  }
});
