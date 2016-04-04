var wordsJSON;
var wordClusters;

var two;

function preload() {
  wordsJSON = loadJSON("assets/bourbon2-words.json");
}

function setup() {
  var elem = document.getElementById('drawing');
  two = new Two({fullscreen: true, type:Two.Types.webgl}).appendTo(elem);

  wordSet.init();
  wordClusters = parseJSON(wordsJSON);
}

function parseJSON(json) {
  parsedClusters = [];
  for (var i = 0; i < json.length; i++) {
    var wc = json[i];
    var cluster = new WordCluster();

    for (var j = 0; j < wc.words.length; j++) {
      var w = wc.words[j];
      cluster.addWord(new Word(w.index, w.x, w.y, w.width, w.height, wc.color));
    }

    parsedClusters.push(cluster);
  }
  return parsedClusters;
}

function draw() {
  for (var i = 0; i < wordClusters.length; i++) {
    wordClusters[i].update();
  }
  two.update();
}

window.addEventListener('keydown', function(e) {
  console.log("key pressed: " + e.keyCode);
  switch(e.keyCode) {
    case 32:
    break;
    default:
    break;
  }
});
