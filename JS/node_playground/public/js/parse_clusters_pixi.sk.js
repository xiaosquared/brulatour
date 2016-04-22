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
  wordClusters = parseJSON(wordsJSON);
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

function parseJSON(json) {
  var count = 0;
  parsedClusters = [];

  for (var i = 0; i < json.length; i++) {
    var wc = json[i];
    var cluster = new WordCluster();

    for (var j = 0; j < wc.words.length; j++) {
      var w = wc.words[j];
      var myWord = new Word(w.index, w.x, w.y, w.width, w.height, wc.color)
      cluster.addWord(myWord);
      stage.addChild(myWord.text);
      count++;
    }
    parsedClusters.push(cluster);
  }

  console.log("how many words: " + count);

  return parsedClusters;
}

window.addEventListener('keydown', function(e) {
  console.log("key pressed: " + e.keyCode);
  switch(e.keyCode) {
    case 32:
      bMoveWords = !bMoveWords;
    break;
  }
});
