// 9.20.16
//
// Prints out "UP!" when elevator starts upward acceleration
// "DOWN!" when elevator starts downward acceleration
//
// GOAL: get rid of false positives from door opening
//

#include <SparkFun_ADXL345.h>    
ADXL345 adxl = ADXL345(10);     

const float UP_THRESH = 61.5;
const float DOWN_THRESH = 56;
const int INTERVAL_SIZE = 10;
const float DEFAULT_VALUE = 59;

float interval[INTERVAL_SIZE];
int offset = 0;
float current_avg;
float last_change_time = millis();

void setup() {
  Serial.begin(9600);
  adxl.powerOn();
  adxl.setRangeSetting(8);
  adxl.setSpiBit(0);

  initInterval();
}

void loop() {
  int x, y, z;
  adxl.readAccel(&x, &y, &z);
  
  int current_time = millis();
  current_avg = getRunningAverage((float)z);
  
  if (current_avg >= UP_THRESH) {
    int diff = current_time - last_change_time ;
    Serial.print("UP! time since last down = ");
    Serial.println(diff);
  }
  else if (current_avg <= DOWN_THRESH) {
    int diff = current_time - last_change_time ;
    Serial.println("DOWN! time since last down = ");
    Serial.println(diff);
  }
  
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

