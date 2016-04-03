var path = require('path');
var express = require('express');

var app = express();
var server = require('http').Server(app);

var staticRoot = path.join(__dirname+'/public/');

//Expose static content
app.use(express.static('public'));

app.get('/', function (req, res) {
  res.sendFile(staticRoot+"index.html");
});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});
