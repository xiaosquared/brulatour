// 9.19.16
// 
// Prints out state of movement based on Z acceleration
// Also prints out how long it takes each time going up
// GOAL: figure out difference between going up 1 floor vs two floors
// and at which point in real time the Arduino could determine what is happening
 
#include <SparkFun_ADXL345.h>         

ADXL345 adxl = ADXL345(10);           

const unsigned int up_start_thresh = 62;       // if greater than this, starting to go up
const unsigned int up_max_thresh = 64;
const unsigned int up_stop_thresh = 55;        // if less than this, starting to stop going up
const unsigned int resting = 59;

const unsigned int DOOR_TIMEOUT = 10000;       // min number of seconds door is opening/closing
unsigned long last_stop_time;
unsigned long last_state_change;

struct Times {
  unsigned int up_start_time;
  unsigned int up_steady_time;
  unsigned int up_stop_time;
};

enum elev_state { REST, UP_START, UP_MIDDLE, UP_END };
extern elev_state state = REST;

void setup() {
  Serial.begin(9600);
  adxl.powerOn();
  adxl.setRangeSetting(8);
  adxl.setSpiBit(0);
}

void loop() {
  int x, y, z;
  adxl.readAccel(&x, &y, &z);
  int currentTime = millis();
  
  switch(state) {
    case REST:
      if (doorTimeoutDone() && (z >= up_start_thresh)) 
        state = UP_START;
        last_state_change = currentTime;
        Times times;
        Serial.println("lifting UP!");
    break;

    case UP_START:
      if (z == up_max_thresh)
        state = UP_MIDDLE;
        times.up_start_time = currentTime - last_state_change;
        last_state_change = currentTime;
        Serial.println("continuing UP!");
    break;

    case UP_MIDDLE:
      if (z <= up_stop_thresh)
        state = UP_END;
        times.up_steady_time = currentTime - last_state_change;
        last_state_change = currentTime;
        Serial.println("slowing UP");
    break;

    case UP_END:
      if (z == resting)
        state = REST;
        times.up_stop_time = currentTime - last_state_change;
        printTimes(times);
        Serial.println("STOPPED!");
    break;
  }
}

boolean doorTimeoutDone() {
  return micros() - last_stop_time >= DOOR_TIMEOUT;
}

void printTimes(Times times) {
  Serial.println("Up Start Time: " + times.up_start_time);
  Serial.println("Up Steady Time: " + times.up_steady_time);
  Serial.println("Up Stop Time: " + times.up_stop_time);
  int total_time = times.up_start_time + times.up_steady_time + times.up_stop_time;
  Serial.println("Total Time Up: " + total_time);
}

