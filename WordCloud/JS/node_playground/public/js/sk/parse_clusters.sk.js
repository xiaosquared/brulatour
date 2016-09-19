// 4.3.16
//
// Parse Cluster JS
//
// Ported JSON parsing code from Processing to JS
// Uses P5 library for JSON. Tried Two.js for drawing but it was too slow.

var wordsJSON;
var wordClusters;

var two;

var bMoveWords = false;
var toMove = 0;

function preload() {
  wordsJSON = loadJSON("assets/bourbon2-words.json");
}

function setup() {
  var elem = document.getElementById('drawing');
  two = new Two({fullscreen: true, type:Two.Types.webgl}).appendTo(elem);

  wordSet.init();
  wordClusters = parseJSON(wordsJSON);

  two.update();
}

function parseJSON(json) {
  var count = 0;
  parsedClusters = [];

  for (var i = 0; i < json.length; i++) {
    var wc = json[i];
    var cluster = new WordCluster();

    for (var j = 0; j < wc.words.length; j++) {
      var w = wc.words[j];
      cluster.addWord(new Word(w.index, w.x, w.y, w.width, w.height, wc.color));
      count++;
    }

    parsedClusters.push(cluster);
  }

  console.log("how many words: " + count);

  return parsedClusters;
}

function draw() {
  if (bMoveWords)
    moveWords();
  two.update();
}

function moveWords() {
  wordClusters[toMove].update();
}

window.addEventListener('keydown', function(e) {
  console.log("key pressed: " + e.keyCode);
  switch(e.keyCode) {
    case 32:
      bMoveWords = !bMoveWords;
    break;
    case 48:
    case 49:
    case 50:
    case 51:
    case 52:
    case 53:
      toMove = e.keyCode - 48;
    break;
    default:
    break;
  }
});
