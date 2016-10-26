// Created 3.4.16, last update 3.12.16
//
// Words As House
//
// Filling polygons to create the shape of a house
//
// TODO:
// Start with sort of simplified house shape

import java.util.*;

JSONArray values;
String filename = "bourbon2";
String inputFilename = filename + ".json";
String outputFilename = filename + "-words.json";

int defaultFontSize = 20;
int totalWords = 50;

WordSet ws;
ArrayList<WordCluster> wordClusters;
WordCluster selectedCluster;

color selectedColor = color(127, 255, 255);
color normalColor = 100;
color dark = 20;
color light = 200;
color medium = 100;
int bkg = 50;

PFont font;

void setup() {
  size(1500, 1000);
  noFill();
  stroke(200);
  
  ws = new WordSet(defaultFontSize);
  font = createFont("American Typewriter", 60);
  textFont(font, defaultFontSize);
  textAlign(LEFT, TOP);
  
  wordClusters = new ArrayList<WordCluster>();
  polygonsFromJSON();
}

void draw() {
  background(bkg);
  
  for (WordCluster wc : wordClusters) {
    wc.draw();
  }
}

void mousePressed() {
  if (selectedCluster != null) {    
    selectedCluster = null;
  }
  
  for (WordCluster wc : wordClusters) {
    if (wc.poly.contains(mouseX, mouseY)) {
      selectedCluster = wc;
      wc.setColor(selectedColor);
    }
  }
}

void mouseDragged() {
  
}

void mouseReleased() {
  
}

void keyPressed() {
  if (key == 10) {
    makeWordsJSON();
  }
  if (key == 'p') {
    for (WordCluster wc : wordClusters) {
      wc.drawPoly = !wc.drawPoly;
    }
  }  
  else if (key == 'b') {
    if (bkg == 50) {
      bkg = 240;
    } else {
      bkg = 50;
    }
  }
  
  else if (selectedCluster != null) {
    switch(key) {
      case 32:
        selectedCluster.populateInsidePolygon(50);
      break;
      case 'e':
        selectedCluster.clearWords();
      break;
      case '1':
        selectedCluster.setColor(dark);
      break;
      case '2':
        selectedCluster.setColor(medium);
      break;
      case '3':
        selectedCluster.setColor(light);
      break;
    }
  }
}

void polygonsFromJSON() {
  values = loadJSONArray(inputFilename);
  for (int i = 0; i < values.size(); i++) {
    JSONArray jpoly = values.getJSONArray(i);
    Polygon poly = new Polygon();
    
    for (int j = 0; j < jpoly.size(); j++) {
      JSONArray jvertex = jpoly.getJSONArray(j);
      int x = jvertex.getInt(0);
      int y = jvertex.getInt(1);
      poly.addVertex(new PVector(x, y));
    }
    
    poly.computeBoundingBox();
    wordClusters.add(new WordCluster(poly));
  }
}

void makeWordsJSON() {
  JSONArray clustersArrayJSON = new JSONArray();
  for (int i = 0; i < wordClusters.size(); i++) {
    WordCluster wc = wordClusters.get(i);  
    
    JSONObject clusterJSON = new JSONObject();
    clusterJSON.setInt("color", wc.c);
    
    JSONArray wordsArrayJSON = new JSONArray();
    for (int j = 0; j < wc.words.size(); j++) {
      Word w = wc.words.get(j);
      JSONObject wordJSON = new JSONObject();
      wordJSON.setInt("index", w.wordIndex);
      wordJSON.setFloat("x", w.position.x);
      wordJSON.setFloat("y", w.position.y);
      wordJSON.setFloat("width", w.fontWidth);
      wordJSON.setFloat("height", w.fontHeight);
      wordsArrayJSON.setJSONObject(j, wordJSON);
    }
    clusterJSON.setJSONArray("words", wordsArrayJSON);
    clustersArrayJSON.setJSONObject(i, clusterJSON); 
  }
  println(clustersArrayJSON);
  saveJSONArray(clustersArrayJSON, "data/" + outputFilename);
}