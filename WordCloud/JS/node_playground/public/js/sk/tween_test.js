// 9.13.16
// Tween Test
//
// Load word cluster into a house
// Explode into random positions
// From random positions, TWEEN back into house

var stats = new Stats();
stats.showPanel(0);
document.body.appendChild(stats.dom);

var wordsJSON, wordClusters, renderer, stage, bMoveWords;
var maxVel = 16;

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
    word.setVelocity(Math.random() * maxVel - maxVel/2,
                     Math.random() * maxVel - maxVel/2);
  }
}

function draw() {
  stats.begin();
  if(bMoveWords)
    moveWords();
  TWEEN.update();
  renderer.render(stage);
  stats.end();
}

function moveWords() {
  for (var i = 0; i < wordClusters.length; i++) {
    wordClusters[i].update();
  }
}

function tweenWords() {
  for (var k = 0; k < wordClusters.length; k++) {
    wc = wordClusters[k];
    for (var i = 0; i < wc.words.length; i++) {
      var w = wc.words[i];
      var tween = new TWEEN.Tween({x: wc.words[i].text.x, y: wc.words[i].text.y, obj: wc.words[i]})
      .to({x: wc.words[i].p_end.x, y: wc.words[i].p_end.y}, 1000)
      .easing(TWEEN.Easing.Quintic.Out)
      .onUpdate(function() {
        this.obj.setPosition(this.x, this.y);
      }).start();
    }
  }
}

window.addEventListener('keydown', function(e) {
  console.log("key pressed: " + e.keyCode);
  switch(e.keyCode) {
    case 32:
      if (bMoveWords)
        tweenWords();
      bMoveWords = !bMoveWords;
      break;
  }
});
