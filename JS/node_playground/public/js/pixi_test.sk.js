// 4.19.16
//
// Pixi Particles Test
//
// Used Pixi to render 5000 words and have them randomly fly around
// Speed is OK!
//
// Need to figure out how to load American Typewriter as a font

var renderer;
var stage;
var words = [];

var bMove = true;
var pixiWidth = window.innerWidth;
var pixiHeight = window.innerHeight;


function setup() {
  wordSet.init();

  // setup the renderer
  renderer = PIXI.autoDetectRenderer(pixiWidth, pixiHeight,{backgroundColor : 0xcccccc});
  document.body.appendChild(renderer.view);

  // create the stage & ParticleContainer
  stage = new PIXI.Container();

  for (var i = 0; i < 5000; i++) {
    var w = new Word(~~(Math.random() * 25),
                    Math.random() * pixiWidth,
                    Math.random() * pixiHeight, 20, 2);
    stage.addChild(w.text);
    words.push(w);
  }

  animate();
}

function animate() {
  requestAnimationFrame(animate);

  if (bMove) {
    for (var i = 0; i < words.length; i++) {
      words[i].update();
    }
    renderer.render(stage);
  }
}

window.addEventListener('keydown', function(e) {
  console.log("key pressed: " + e.keyCode);
  switch(e.keyCode) {
    case 32:
      bMove = !bMove;
    break;
  }
});
