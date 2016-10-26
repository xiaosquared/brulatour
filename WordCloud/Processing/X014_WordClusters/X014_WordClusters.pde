// Created 2.29.16, first version completed 3.2.16
//
// Word Clusters
//
// Word drawing controlled by individual objects rather than global draw loop
// Treats individual words as particles. Figures out font-sized based on width constraint
// Simple demo renders and bunch of words with random positions & velocities.
//

import java.util.*;

int defaultFontSize = 20;
int totalWords = 50;

WordSet ws;
WordCluster cluster;
WordCluster cluster2;

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
  
  Polygon poly = new Polygon();
  poly.addDefaultVertices();
  poly.computeBoundingBox();
  cluster = new WordCluster(poly);
  
  Polygon poly2 = new Polygon();
  poly2.addDefaultVertices2();
  poly2.computeBoundingBox();
  cluster2 = new WordCluster(poly2);
  cluster2.setColor(color(100));
}

void draw() {
  background(50);
  cluster.draw();
  cluster2.draw();
}

void mousePressed() {
  cluster.poly.selectVertex(mouseX, mouseY);
  cluster2.poly.selectVertex(mouseX, mouseY);
}

void mouseDragged() {
  cluster.poly.setSelectedVertex(mouseX, mouseY);
  cluster2.poly.setSelectedVertex(mouseX, mouseY);
}

void mouseReleased() {
  cluster.poly.unselectVertex();
  cluster2.poly.unselectVertex();
}

void keyPressed() {
  if (key == 32) {
    cluster.populateInsidePolygon(50);
    cluster2.populateInsidePolygon(50);
  } else if (key == 'e') {
    cluster.clearWords();
    cluster2.clearWords();
  } else if (key == 'p') {
    cluster.drawPoly = !cluster.drawPoly;
    cluster2.drawPoly = !cluster2.drawPoly;
  }
}