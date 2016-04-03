// Created 3.13.16
//
// WordClusters Animation
//
// Interpolates between grid positions and house based on mouse Y
// kind of slow...


import java.util.*;

String filename = "bourbon2-words.json";

WordSet ws;
ArrayList<WordCluster> wordClusters;

PFont font;
int defaultFontSize = 20;

int bkg = 50;

void setup() {
  size(1500, 1000);
  noFill();
  stroke(200);

  ws = new WordSet(defaultFontSize);
  font = createFont("American Typewriter", 60);
  textFont(font, defaultFontSize);
  textAlign(LEFT, TOP);
  
  wordClusters = new ArrayList<WordCluster>();
  parseJSON();
}

void draw() {
  background(bkg);
  for (WordCluster wc : wordClusters) {
    wc.draw();
  }
}

void parseJSON() {
  int totalWords = 0;
  
  JSONArray clustersArrayJSON = loadJSONArray(filename);
  for (int i = 0; i < clustersArrayJSON.size(); i++) {
    JSONObject clusterJSON = clustersArrayJSON.getJSONObject(i);

    WordCluster wc = new WordCluster();
    wordClusters.add(wc);
    wc.c = clusterJSON.getInt("color");
    
    JSONArray wordsArrayJSON = clusterJSON.getJSONArray("words");
    for (int j = 0; j < wordsArrayJSON.size(); j++) {
      JSONObject wordJSON = wordsArrayJSON.getJSONObject(j);
      int index = wordJSON.getInt("index");
      float w = wordJSON.getFloat("width");
      float h = wordJSON.getFloat("height");
      PVector p = new PVector(wordJSON.getFloat("x"), wordJSON.getFloat("y"));
      
      Word word = new Word(wc, index, w, h, p);
      wc.addWord(word);
      
      totalWords ++;
    }
  }
  
  println("Total Words: " + totalWords);
}