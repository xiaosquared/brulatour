// 10.5.16
//
// Button Test
//
// Push to print to serial

const int GREEN = 2;
const int RED = 3;
const int YELLOW = 4;
const int BLUE = 5;

int greenState, redState, yellowState, blueState;
int greenPrev, redPrev, yellowPrev, bluePrev;
int greenTime, redTime, yellowTime, blueTime;
int timeOut = 500;

void setup() {
  Serial.begin(9600);
  pinMode(GREEN, INPUT);
  pinMode(RED, INPUT);
  pinMode(YELLOW, INPUT);
  pinMode(BLUE, INPUT);

  greenPrev = HIGH;
  redPrev = HIGH;
  yellowPrev = HIGH;
  bluePrev = HIGH;

  greenTime = millis();
  redTime = greenTime;
  yellowTime = greenTime;
  blueTime = greenTime;
}

void loop() {
  greenState = digitalRead(GREEN);
  redState = digitalRead(RED);
  yellowState = digitalRead(YELLOW);
  blueState = digitalRead(BLUE);

  int currentTime = millis();
  
  if (greenState == LOW && greenPrev == HIGH 
                        && currentTime - greenTime > timeOut) {
    Serial.println("GREEN!");
    greenTime = currentTime;
  }
  if (redState == LOW && redPrev == HIGH
                       && currentTime - redTime > timeOut) {
    Serial.println("RED!");
    redTime = currentTime;
  }
  if (yellowState == LOW && yellowPrev == HIGH
                        && currentTime - yellowTime > timeOut) {
    Serial.println("YELLOW!");
    yellowTime = currentTime;
  }
  if (blueState == LOW && bluePrev == HIGH
                        && currentTime - blueTime > timeOut) {
    Serial.println("BLUE!");
    blueTime = currentTime;
  }

  greenPrev = greenState;
  redPrev = redState;
  yellowPrev = yellowState;
  bluePrev = blueState;
}
