// 11.11.17
//
// Websocket Client
//
// Using the processing_websockets library: 
// https://github.com/alexandrainst/processing_websockets
//

import websockets.*;

WebsocketClient client;
String data;

void setup() {
  size(200, 200);
  client = new WebsocketClient(this, "ws://dndrk.media.mit.edu:3333");
}

void draw() {
  
}

void webSocketEvent(String msg) {
  println(msg);
}

void keyPressed() {
  client.sendMessage("i love cute dd");
}