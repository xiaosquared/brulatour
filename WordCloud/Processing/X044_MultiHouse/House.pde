class House {
  
  ArrayList<WordCluster> wordClusters;
  
  PVector origin;  // (x, y) to eliminate space from left and upper edge
  float width = 0;  
  
  House(String filename, WordSet ws, PVector origin, float width) {
    wordClusters = new ArrayList<WordCluster>();
  
    parseJSON(filename, wordClusters, ws);
    
    this.origin = origin;
    this.width = width;
  }
  
  void draw(float scale) {
    draw(0, 0, scale);
  }
  
  void draw(float xTrans, float yTrans, float scale) {
    for (WordCluster wc : wordClusters) {
      wc.draw((xTrans - origin.x) * scale, (yTrans - origin.y) * scale, scale);
    }
  }
  
  // Helper function to parse JSON
  private void parseJSON(String filename, ArrayList<WordCluster> wordClusters, WordSet ws) {
    JSONArray myArray = loadJSONArray(filename);
    
    for (int i = 0; i < myArray.size();i++) {
      JSONObject clusterJSON = myArray.getJSONObject(i);
      WordCluster cluster = new WordCluster();
      wordClusters.add(cluster);
      cluster.c = clusterJSON.getInt("color");
      
      JSONArray wordsJSON = clusterJSON.getJSONArray("words");
      for (int j = 0; j < wordsJSON.size(); j++) {
        JSONObject wJSON = wordsJSON.getJSONObject(j);
        int index = wJSON.getInt("index");
        float w = wJSON.getFloat("width");
        float h = wJSON.getFloat("height");
        PVector p = new PVector(wJSON.getFloat("x"), wJSON.getFloat("y"));
        
        Word word = new Word(index, w, h, p, ws);
        cluster.addWord(word); 
      }
    }
  }

}