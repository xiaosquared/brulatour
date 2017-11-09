// 10.17.16
//
// Up Down V2

// Detects when elevator is going up or down and turns on LEDs
// Turns on a second LED if going up 2 floors

//*********** SET: TWO_FLOOR_TIME!

#include <SparkFun_ADXL345.h>

ADXL345 adxl = ADXL345(10);     

// Z Acceleration
float REST, UP_THRESH, DOWN_THRESH, UP_STOP_THRESH, DOWN_STOP_THRESH;
float THRESH_AMT = 2.5;

// Running average
const int INTERVAL_SIZE = 10;
float interval[INTERVAL_SIZE];
int offset = 0;

int CHANGE_TIMEOUT = 5000; // WHAT ABOUT FOR THE VERY FIRST TIME???
unsigned long lastChangeTime = millis() + CHANGE_TIMEOUT;
unsigned long currentTime;

// Indicator Lights
int UP_LED = 3;
int DOWN_LED = 4;
int TWO_LED = 2;

// Buttons
int REST_BTN = 9;
int UP_BTN = 7;
int DOWN_BTN = 8;
int CALIBRATE_BTN = 6;
unsigned long lastButtonPress = millis();
int BUTTON_TIMEOUT = 1500;

// State
enum elevState {RESTING, UP, DOWN};
elevState state = RESTING;
int upTriggerCount = 0;
int downTriggerCount = 0;
int stopTriggerCount = 0;

int TRIGGER_THRESH = 20;  // how many consecutive frames above or below thresh
                          // to switch states
int STOP_THRESH = 30;     

// One or two floors
int TWO_FLOOR_TIME_UP = 4000;
int TWO_FLOOR_TIME_DOWN = 4800; 
int TIME_OUT_TIME = 7000;
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

  delay(5);  
  switch(state) {
    case RESTING:
      if (accel > UP_THRESH) {
        upTriggerCount ++;
        downTriggerCount = 0;
      } else if (accel < DOWN_THRESH) {
        upTriggerCount = 0;
        downTriggerCount ++;
      } else {
        upTriggerCount = max(0, upTriggerCount - 5);
        downTriggerCount = max (0, downTriggerCount - 5);
      }

      if (currentTime - lastChangeTime > CHANGE_TIMEOUT) {
        if (upTriggerCount > TRIGGER_THRESH) {
          state = UP;
          digitalWrite(UP_LED, HIGH);
          
          Serial.println("UP!");
          printValue(".....up", millis());
          
          upTriggerCount = 0;
          downTriggerCount = 0;
          stopTriggerCount = 0;

          lastChangeTime = currentTime;
        } 
        
        else if (downTriggerCount > TRIGGER_THRESH) {
          state = DOWN;
          digitalWrite(DOWN_LED, HIGH);
          
          Serial.println("DOWN!");
          printValue(".....down", millis());
          
          upTriggerCount = 0;
          downTriggerCount = 0;
          stopTriggerCount = 0;
          
          lastChangeTime = currentTime;
        }
      }
    break;

    case UP:
      if (currentTime - lastChangeTime > TIME_OUT_TIME) {
        stopProcedure();
      }
      
      else if (currentTime - lastChangeTime > TWO_FLOOR_TIME_UP) {
        digitalWrite(TWO_LED, HIGH);
      }
      
      if (accel < UP_STOP_THRESH) {
          stopTriggerCount ++;  
      } else if (accel < UP_STOP_THRESH) {
        stopTriggerCount = max(0, stopTriggerCount - 5);
      }
      
      if (stopTriggerCount > STOP_THRESH) {
          stopProcedure();
      }
    break;

    case DOWN:
      if (currentTime - lastChangeTime > TIME_OUT_TIME) {
        stopProcedure();
      } 
      else if (currentTime - lastChangeTime > TWO_FLOOR_TIME_DOWN) {
        digitalWrite(TWO_LED, HIGH);
      }
      
      if (accel > DOWN_STOP_THRESH) {
        stopTriggerCount ++;
      } else if (accel < DOWN_STOP_THRESH) {
        stopTriggerCount = max(0, stopTriggerCount - 5);
      }

      
      if (stopTriggerCount > STOP_THRESH) {
        stopProcedure();
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
  for (int i = 2; i <= 5; i++)
    pinMode(i, OUTPUT);
}

void setAllLights(int state) {
  for (int i = 2; i <= 5; i++) {
    digitalWrite(i, state);
  }
}

void stopProcedure() {
  digitalWrite(UP_LED, LOW);
  digitalWrite(TWO_LED, LOW);
  digitalWrite(DOWN_LED, LOW);
  digitalWrite(TWO_LED, LOW);
                
  Serial.println("STOP!");
  printValue(".....stop", millis());
          
  state = RESTING;
  stopTriggerCount = 0;

  lastChangeTime = currentTime;
}

void calibrateSensors() {
  setAllLights(HIGH);
  float frames = 10000;

  double totalAccel = 0;
  for (int i = 0; i < frames; i++) {
    float accel = getZAccel();
    totalAccel += accel;
  }
  REST = totalAccel/frames;
  UP_THRESH = REST + THRESH_AMT - 0.5;
  DOWN_THRESH = REST - THRESH_AMT;
  UP_STOP_THRESH = DOWN_THRESH - 0.75;
  DOWN_STOP_THRESH = UP_THRESH + 0.75;

  initInterval(REST);
  setAllLights(LOW);
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
    digitalWrite(TWO_LED, LOW);
    
    printValue("rest", millis());
  } else if (digitalRead(UP_BTN) == LOW && currentTime - lastButtonPress > BUTTON_TIMEOUT) {
    pressed = true;
    state = UP;
    digitalWrite(UP_LED, HIGH);
    digitalWrite(DOWN_LED, LOW);
    digitalWrite(TWO_LED, LOW);

    printValue("up", millis());
  } else if (digitalRead(DOWN_BTN) == LOW && currentTime - lastButtonPress > BUTTON_TIMEOUT) {
    pressed = true;
    state = DOWN;
    digitalWrite(UP_LED, LOW);
    digitalWrite(DOWN_LED, HIGH);
    digitalWrite(TWO_LED, LOW);

    printValue("down", millis());
  } else if (digitalRead(CALIBRATE_BTN) == LOW && currentTime - lastButtonPress > BUTTON_TIMEOUT) {
      pressed = true;
      state = RESTING;
      digitalWrite(UP_LED, LOW);
      digitalWrite(DOWN_LED, LOW);
      digitalWrite(TWO_LED, LOW);
      calibrateSensors();
  }

  if (pressed) {
    lastButtonPress = currentTime;
    return true;
  }

  return false;
}




