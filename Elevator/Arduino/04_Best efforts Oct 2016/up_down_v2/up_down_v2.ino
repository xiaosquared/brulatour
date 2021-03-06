// 10.11.16
//
// Up Down V2
//
// Detects when elevator is going up or down and turns on LEDs

#include <SparkFun_ADXL345.h>

ADXL345 adxl = ADXL345(10);     

// Z Acceleration
float REST, UP_THRESH, DOWN_THRESH, UP_STOP_THRESH, DOWN_STOP_THRESH;
float THRESH_AMT = 3;

// Running average
const int INTERVAL_SIZE = 10;
float interval[INTERVAL_SIZE];
int offset = 0;
unsigned long lastChangeTime = millis();
unsigned long currentTime;
int CHANGE_TIMEOUT = 5000;

// Indicator Lights
int UP_LED = 3;
int DOWN_LED = 4;

// Buttons
int REST_BTN = 9;
int UP_BTN = 7;
int DOWN_BTN = 8;
unsigned long lastButtonPress = millis();
int BUTTON_TIMEOUT = 500;

// state
enum elevState {RESTING, UP, DOWN};
extern elevState state = RESTING;
int upTriggerCount = 0;
int downTriggerCount = 0;
int stopTriggerCount = 0;

int TRIGGER_THRESH = 30;  // how many consecutive frames above or below thres
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
    
  switch(state) {
    case RESTING:
      if (accel > UP_THRESH) {
        Serial.println(accel);
        upTriggerCount ++;
        downTriggerCount = 0;
      } else if (accel < DOWN_THRESH) {
        Serial.println(accel);
        upTriggerCount = 0;
        downTriggerCount ++;
      } else {
        upTriggerCount = 0;
        downTriggerCount = 0;
      }

      if (currentTime - lastChangeTime > CHANGE_TIMEOUT) {
        if (upTriggerCount > TRIGGER_THRESH) {
          state = UP;
          digitalWrite(UP_LED, HIGH);
          upTriggerCount = 0;
          downTriggerCount = 0;

          lastChangeTime = currentTime;
        } else if (downTriggerCount > TRIGGER_THRESH) {
          state = DOWN;
          digitalWrite(DOWN_LED, HIGH);
          upTriggerCount = 0;
          downTriggerCount = 0;

          lastChangeTime = currentTime;
        }
      }
    break;

    case UP:
      if (accel < UP_STOP_THRESH) {
        stopTriggerCount ++;  
      } 
      if (stopTriggerCount > STOP_THRESH) {
        digitalWrite(UP_LED, LOW);
        state = RESTING;
        stopTriggerCount = 0;

        lastChangeTime = currentTime;
      }
      
    break;

    case DOWN:
      if (accel > DOWN_STOP_THRESH) {
        stopTriggerCount ++;
      }
      if (stopTriggerCount > STOP_THRESH) {
        digitalWrite(DOWN_LED, LOW);
        state = RESTING;
        stopTriggerCount = 0;
        
        lastChangeTime = currentTime;
      }
    break;
  }
}

/////////////////////////////////////////////////////////////////////////////

void initSensors() {
  adxl.powerOn();
  adxl.setRangeSetting(8);
  adxl.setSpiBit(0);
}

void initButtons() {
  for (int i = 6; i <= 9; i++)
    pinMode(i, INPUT);
}

void initLights() {
  for (int i = 1; i <= 5; i++)
    pinMode(i, OUTPUT);
}

void setAllLights(int state) {
  for (int i = 1; i <= 5; i++) {
    digitalWrite(i, state);
  }
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
  DOWN_THRESH = REST - THRESH_AMT;
  UP_STOP_THRESH = DOWN_THRESH;
  DOWN_STOP_THRESH = REST + THRESH_AMT/2;

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

boolean handleButtons() {
  boolean pressed = false;
  if (digitalRead(REST_BTN) == LOW && currentTime - lastButtonPress > BUTTON_TIMEOUT) {
    pressed = true;
    state = RESTING;
    digitalWrite(UP_LED, LOW);
    digitalWrite(DOWN_LED, LOW);
  } else if (digitalRead(UP_BTN) == LOW && currentTime - lastButtonPress > BUTTON_TIMEOUT) {
    pressed = true;
    state = UP;
    digitalWrite(UP_LED, HIGH);
    digitalWrite(DOWN_LED, LOW);
  } else if (digitalRead(DOWN_BTN) == LOW && currentTime - lastButtonPress > BUTTON_TIMEOUT) {
    pressed = true;
    state = DOWN;
    digitalWrite(UP_LED, LOW);
    digitalWrite(DOWN_LED, HIGH);
  }

  if (pressed) {
    lastButtonPress = currentTime;
    return true;
  }

  return false;
}



