// 9.20.16
//
// Prints GOING UP, GOING DOWN, REST
// figures out the time in between state changes

#include <SparkFun_ADXL345.h>         

ADXL345 adxl = ADXL345(10);           

const float UP_THRESH = 62.5;
const float DOWN_THRESH = 55;
const int INTERVAL_SIZE = 10;
const float DEFAULT_VALUE = 59;

float interval[INTERVAL_SIZE];
int offset = 0;
float current_avg;
float last_change_time = millis();

enum elev_state { REST, UP, UP_END, DOWN, DOWN_END };
extern elev_state state = REST;

void setup() {
  Serial.begin(9600);
  adxl.powerOn();
  adxl.setRangeSetting(8);
  adxl.setSpiBit(0);

  Serial.write(27);       // ESC command
  Serial.print("[2J");    // clear screen command
  Serial.write(27);
  Serial.print("[H");     // cursor to home command

  initInterval();
}

void loop() {
  int x, y, z;
  adxl.readAccel(&x, &y, &z);  
  int current_time = millis();
  current_avg = getRunningAverage((float)z);

  int diff = 0;
  switch(state) {
    case REST:
      if (current_avg >= UP_THRESH) {
        diff = current_time - last_change_time;
        Serial.print("----------UP! ");
        Serial.println(diff);
        state = UP;
      }
      else if (current_avg <= DOWN_THRESH) {
        diff = current_time - last_change_time;
        Serial.print("--------DOWN! ");
        Serial.println(diff);
        state = DOWN;
      }
    break;

    case UP:
      if (current_avg <= DOWN_THRESH) {
        state = UP_END;
      }
    break;

    case UP_END:
      if (current_avg == DEFAULT_VALUE) {
        diff = current_time - last_change_time;
        Serial.print("--------REST! ");
        Serial.println(diff);
        state = REST;
      }
    break;

    case DOWN:
      if (current_avg >= UP_THRESH) {
        state = DOWN_END;
      }
    break;

    case DOWN_END:
      if (current_avg == DEFAULT_VALUE) {
        diff = current_time - last_change_time;
        Serial.print("--------REST! ");
        Serial.println(diff);
        state = REST;
      }
    break;
  }
  if (diff != 0)
    last_change_time = current_time;
}

void initInterval() {
  for (int i = 0; i < INTERVAL_SIZE; i++) {
    interval[i] = DEFAULT_VALUE;
  }
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
