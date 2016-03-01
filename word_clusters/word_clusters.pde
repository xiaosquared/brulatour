// 2.29.16
//
// Word Clusters
//
// Word drawing controlled by individual objects rather than global draw loop
// Treats individual words as particles. Figures out font-sized based on width constraint
// Simple demo renders and bunch of words with random positions & velocities.
//
// TODO: 
// - Diff clusters with diff colors. 
// - Constrain clusters with polygons
// - Base polygons off French Quarter houses

import java.util.*;

int defaultFontSize = 20;
int totalWords = 50;

WordSet ws;
WordCluster cluster;

void setup() {
  size(800, 800);
  noFill();
  stroke(200);
  textAlign(LEFT, TOP);
  background(50);
  
  ws = new WordSet(defaultFontSize);
  
  cluster = new WordCluster();
  cluster.populateRandomly(totalWords);
}

void draw() {
  background(50);
  cluster.draw();
}