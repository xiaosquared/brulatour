// 10.7.16
//
// LED Test
// 
// Cycle through blinking LED just to test connections

void setup() {
  for (int i = 1; i <=5; i++) {
    pinMode(i, OUTPUT);
  }
}

void loop() {
  for (int i = 1; i <= 5; i++) {
    digitalWrite(i, HIGH);
    delay(500);
    digitalWrite(i, LOW);
    delay(500); 
  }
}


