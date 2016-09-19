// Utility FUNCTIONS
// requires p5.min.js to be loaded first

function parseJSON(json, doToWord) {
  var count = 0;
  parsedClusters = [];

  for (var i = 0; i < json.length; i++) {
    var wc = json[i];
    var cluster = new WordCluster();

    for (var j = 0; j < wc.words.length; j++) {
      var w = wc.words[j];
      var myWord = new Word(w.index, w.x, w.y, w.height, wc.color)
      doToWord(myWord);
      cluster.addWord(myWord);
      stage.addChild(myWord.text);
      count++;
    }
    parsedClusters.push(cluster);
  }

  console.log("how many words: " + count);

  return parsedClusters;
}
