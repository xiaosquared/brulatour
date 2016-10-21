// 10 17.16
//
// Calibrate Floor Times
//
// Computes the time between floors, prints to serial
//
//****** TO TEST *******
// Open Serial Monitor. 
// Take a few trips going only one floor at a time
// copy the numbers and use to set threshold
// Might need to tweak UP_STOP_THRESH & DOWN_STOP_THRESH
//


#include <SparkFun_ADXL345.h>

ADXL345 adxl = ADXL345(10);

// Z Acceleration
float REST, UP_THRESH, DOWN_THRESH, UP_STOP_THRESH, DOWN_STOP_THRESH;
float THRESH_AMT = 2;

// Running average
const int INTERVAL_SIZE = 10;
float interval[INTERVAL_SIZE];
int offset = 0;
unsigned long lastChangeTime = millis();
unsigned long currentTime;
int CHANGE_TIMEOUT = 2000;

// Indicator Lights
int UP_LED = 3;
int DOWN_LED = 4;
int TWO_LED = 2;

// Buttons
int REST_BTN = 9;
int UP_BTN = 7;
int DOWN_BTN = 8;
unsigned long lastButtonPress = millis();
int BUTTON_TIMEOUT = 500;

// State
enum elevState {RESTING, UP, DOWN};
extern elevState state = RESTING;
int upTriggerCount = 0;
int downTriggerCount = 0;
int stopTriggerCount = 0;

int TRIGGER_THRESH = 20;  // how many consecutive frames above or below thresh
                          // to switch states
int STOP_THRESH = 70;    

/////////////////////////////////////////////////////////////////////////////


void setup() {
  Serial.begin(9600);

  initLights();
  initButtons();
  initSensors();
  calibrateSensors();
}

void loop() {
  float accel = getZAverage();
  currentTime = millis();

  if (handleButtons())
    return;

  delay(10);
  String startMoving; // String for direction of movement
  boolean stopMoving; 
  
  switch(state) {
    case RESTING:
      processAccel(accel);
      startMoving = checkUpDown();
      if (startMoving != "") {
          lastChangeTime = currentTime;
        Serial.print(startMoving);
        Serial.print(", duration: ");
      }
    break;

    case UP:
      stopMoving = handleUpDown(accel, UP_STOP_THRESH, UP_LED);
    break;
    
    case DOWN:
      stopMoving = handleUpDown(DOWN_STOP_THRESH, accel, DOWN_LED);
    break;
  }

  if (stopMoving) {
    int duration = currentTime - lastChangeTime;
    Serial.println(duration);
    
    lastChangeTime = currentTime;
  }
}

/////////////////////////////////////////////////////////////////////////////

void processAccel(float accel) {
  if (accel > UP_THRESH) {
    upTriggerCount ++;
    downTriggerCount = 0;
  } else if (accel < DOWN_THRESH) {
    upTriggerCount = 0;
    downTriggerCount ++;
  } else {
    upTriggerCount = 0;
    downTriggerCount = 0;
  }
}

String checkUpDown() {
  if (currentTime - lastChangeTime > CHANGE_TIMEOUT) {
    if (upTriggerCount > TRIGGER_THRESH) {
      digitalWrite(UP_LED, HIGH);
      state = UP;
      upTriggerCount = 0;
      downTriggerCount = 0;
      return "UP";
      
    } else if (downTriggerCount > TRIGGER_THRESH) {
      digitalWrite(DOWN_LED, HIGH);
      state = DOWN;
      upTriggerCount = 0;
      downTriggerCount = 0;
      return "DOWN";
    }
  }
  return "";
}

boolean handleUpDown(float accel1, float accel2, int LED) {
  if (accel1 < accel2) {
    stopTriggerCount++;
  }
  if (stopTriggerCount > STOP_THRESH) {
    digitalWrite(LED, LOW);
    state = RESTING;
    stopTriggerCount = 0;
    return true;
  }
  return false;
}


boolean handleButtons() {
  boolean pressed = false;
  if (digitalRead(REST_BTN) == LOW && currentTime - lastButtonPress > BUTTON_TIMEOUT) {
    pressed = true;
    state = RESTING;
    digitalWrite(UP_LED, LOW);
    digitalWrite(DOWN_LED, LOW);
    digitalWrite(TWO_LED, LOW);
  } else if (digitalRead(UP_BTN) == LOW && currentTime - lastButtonPress > BUTTON_TIMEOUT) {
    pressed = true;
    state = UP;
    digitalWrite(UP_LED, HIGH);
    digitalWrite(DOWN_LED, LOW);
    digitalWrite(TWO_LED, LOW);
  } else if (digitalRead(DOWN_BTN) == LOW && currentTime - lastButtonPress > BUTTON_TIMEOUT) {
    pressed = true;
    state = DOWN;
    digitalWrite(UP_LED, LOW);
    digitalWrite(DOWN_LED, HIGH);
    digitalWrite(TWO_LED, LOW);
  }

  if (pressed) {
    lastButtonPress = currentTime;
    return true;
  }
  return false;
}
/////////////////////////////////////////////////////////////////////////////

void initLights() {
  for (int i = 2; i <= 5; i++)
    pinMode(i, OUTPUT);
}

void setAllLights(int state) {
  for (int i = 2; i <= 5; i++) {
    digitalWrite(i, state);
  }
}

void initButtons() {
  for (int i = 6; i <= 9; i++)
    pinMode(i, INPUT);
}

void initSensors() {
  adxl.powerOn();
  adxl.setRangeSetting(8);
  adxl.setSpiBit(0);
}

void calibrateSensors() {
  setAllLights(HIGH);
  float frames = 5000;

  double totalAccel = 0;
  for (int i = 0; i < frames; i++) {
    float accel = getZAccel();
    totalAccel += accel;
  }
  REST = totalAccel/frames;
  UP_THRESH = REST + THRESH_AMT;
  DOWN_THRESH = REST - THRESH_AMT + 0.5;
  UP_STOP_THRESH = DOWN_THRESH;
  DOWN_STOP_THRESH = REST + THRESH_AMT/4;

  initInterval(REST);
  setAllLights(LOW);
  printValue("Total", totalAccel);
  printValue("Stationary Z Accel", REST);
}

void printValue(String label, float val) {
  Serial.print(label);
  Serial.print(": ");
  Serial.println(val);
}

float getZAccel() {
  int x, y, z;
  adxl.readAccel(&x, &y, &z);
  return z;
}

void initInterval(float val) {
  for (int i = 0; i < INTERVAL_SIZE;i++) {
    interval[i] = val;
  }
}

float getZAverage() {
  return getRunningAverage(getZAccel());
}

float getRunningAverage(float new_z) {
   interval[offset] = new_z;
   float sum = 0;
   for (int i = 0; i < INTERVAL_SIZE; i++) {
     sum+=interval[i];
   }

   // adjust offset
   offset = (offset+1)%INTERVAL_SIZE;

   return sum/(float)INTERVAL_SIZE;
}


