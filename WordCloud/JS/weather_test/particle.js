function Particle(x, y, w) {
  this.position = createVector(x, y);
  this.velocity = createVector(0, 0);
  this.acceleration = createVector(0, 0.1);
  this.word = w;
  this.lifespan = 255;

  this.update = function() {
    this.velocity.add(this.acceleration);
    this.position.add(this.velocity);
    this.lifespan--;
  }

  this.draw = function() {
    noStroke();
    fill(200, this.lifeSpan);

    push();
    translate(this.position.x, this.position.y);
    rotate(-HALF_PI);
    text(this.word, 0, 0);
    pop();
  }

  this.run = function() {
    this.update();
    this.draw();
  }
}
