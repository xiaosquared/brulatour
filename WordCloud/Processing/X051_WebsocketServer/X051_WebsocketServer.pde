// 11.11.17
//
// Websocket Server
//

import websockets.*;

WebsocketServer server;
PFont myFont;

void setup() {
  size(400, 200);
  server = new WebsocketServer(this, 3333, "/");
  
  myFont = createFont("Verdana", 16);
  textFont(myFont);
  textAlign(LEFT, TOP);
  
  background(0);
  text("Server Started", 30, 25);
}

void draw() {
}

void mousePressed() {
  println(mouseX + ", " + mouseY);
}

void keyPressed() {
  server.sendMessage("hello world");
}