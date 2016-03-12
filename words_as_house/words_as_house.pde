// Created 3.4.16, updated 3.11.16
//
// Words As House
//
// Filling polygons to create the shape of a house
//
// TODO:
// Start with sort of simplified house shape

import java.util.*;

String filename = "polygons.json";
JSONArray values;

int defaultFontSize = 20;
int totalWords = 50;

WordSet ws;
ArrayList<WordCluster> wordClusters;
WordCluster selectedCluster;

color selectedColor = color(127, 255, 255);
color normalColor = color(100);
color dark = color(20);
color light = color(200);
color medium = color(100);


PFont font;

void setup() {
  size(800, 800);
  noFill();
  stroke(200);
  textAlign(LEFT, TOP);
  background(50);
  
  ws = new WordSet(defaultFontSize);

  font = createFont("American Typewriter", 60);
  textFont(font, defaultFontSize);
  textAlign(LEFT, TOP);
  
  wordClusters = new ArrayList<WordCluster>();
  polygonsFromJSON();
}

void draw() {
  background(255);
  
  for (WordCluster wc : wordClusters) {
    wc.draw();
  }
}

void mousePressed() {
  if (selectedCluster != null) {
    selectedCluster.setColor(normalColor);
    selectedCluster = null;
  }
  
  for (WordCluster wc : wordClusters) {
    if (wc.poly.contains(mouseX, mouseY)) {
      println("hi");
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
  if (key == 'p') {
    for (WordCluster wc : wordClusters) {
      wc.drawPoly = !wc.drawPoly;
    }
  } else if (selectedCluster != null) {
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
  values = loadJSONArray(filename);
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