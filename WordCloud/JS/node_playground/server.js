var path = require('path');
var express = require('express');
var app = express();
var server = require('http').Server(app);
var io = require('socket.io')(server);
var staticRoot = path.join(__dirname+'/public/');

//Expose static content
app.use(express.static('public'));

app.get('/', function (req, res) {
  res.sendFile(staticRoot+"index.html");
});

app.get('/r', function (req, res) {
  res.sendFile(staticRoot+"remote.html");
});

// socket stuff
io.on('connection', function(socket) {
  console.log("a client has connected!");

  socket.on('disconnect', function() {
    console.log('a client has disconnected');
  });

  socket.on('word', function(msg) {
    console.log('word', msg);
    io.emit('word', msg);
  });
})

server.listen(3000, function () {
  var port = server.address().port;
  var host = server.address().address;
  (host == '::') ? host = 'localhost' : host = host;
  console.log('Listening at http://%s:%s', host, port);
});
