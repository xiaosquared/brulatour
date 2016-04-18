var renderer = PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight,{backgroundColor : 0xcccccc});
document.body.appendChild(renderer.view);

// create stage
var stage = new PIXI.Container();

var basicText = new PIXI.Text('hello world!');
basicText.x = 30;
basicText.y = 90;

stage.addChild(basicText);

animate();

function animate() {
  requestAnimationFrame(animate);

  renderer.render(stage);
}
