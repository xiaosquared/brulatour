// 1.16.18
//
// CSV Parsing
//
// Example from https://processing.org/reference/loadTable_.html
// The following short CSV file called "mammals.csv" is parsed 
// in the code below. It must be in the project's "data" folder.
//
// id,species,name
// 0,Capra hircus,Goat
// 1,Panthera pardus,Leopard
// 2,Equus zebra,Zebra
//
// Also CSV writing. 
// 

Table parsed_table;
Table write_table;

void setup() {
  loadTable();
  writeTable();
}

void draw() {}

void loadTable() {
  parsed_table = loadTable("nola.csv");
  
  println(parsed_table.getRowCount() + " total rows in table");
  for (int row = 0; row < parsed_table.getRowCount(); row++) { 
    for (int col = 0; col < parsed_table.getColumnCount(); col++) {
      String s = parsed_table.getString(row, col);
      println(row + ", " + col + " - " + s);
    }
  }
}

void writeTable() {
  write_table = new Table();
  int i = 0;
  while (i < 3) {
    TableRow myRow = write_table.addRow();
    for (int col = 0; col < 3; col++) {
      myRow.setString(col, "hello");
    }
    
    i++;
  }
  saveTable(write_table, "data/new.csv");
  println("done");
}

void keyPressed() {
  
}