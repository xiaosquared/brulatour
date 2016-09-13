// initialize everything, web server, socket.io, filesystem, johnny-five
var app = require('http').createServer(handler)
  , io = require('socket.io').listen(app)
  , fs = require('fs')
  , five = require("johnny-five"),
  board,servo,led,led2,sensor;

board = new five.Board();

// on board ready
board.on('ready', function(){
  // init LED on pin 13, strobe every 1000 ms
  led = new five.Led(13).strobe(1000);
  led2 = new five.Led(10).strobe(500);

  // poll sensor every second
  sensor = new five.Sensor({
    pin: 'A0',
    freq: 500
  });

});

// make webserver listen on port 80
app.listen(3000);

// handle web server
function handler(req, res) {
  fs.readFile(__dirname + '/index.html',
  function(err, data) {
    if (err) {
      res.writeHead(500);
      return res.end('Error loading index.html');
    }

    res.writeHead(200);
    res.end(data);
  });
}

io.sockets.on('connection', function (socket) {
  socket.emit('news', { hello: 'world' });

  // if board is ready
  if(board.isReady){
    // read in sensor data, pass to browser
    sensor.on("data",function(){
      console.log(this.raw);
      socket.emit('sensor', {raw: this.raw });
    });
  }

  socket.on('led', function (data) {
    console.log(data);
     if(board.isReady){ led2.strobe(data.delay); }
  });

});
