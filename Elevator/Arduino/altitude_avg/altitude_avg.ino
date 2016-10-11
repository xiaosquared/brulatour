// 10.5.16
// 
// Altitude Average
//
// Detects current altitude based on pressure sensor
// and running average of past 10 values

#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BMP085_U.h>

float altitude, avgAltitude;
Adafruit_BMP085_Unified bmp = Adafruit_BMP085_Unified(10085);
float seaLevelPressure = 1028;

const float NO_RESULT = -9999;
const int INTERVAL_SIZE = 10;
float interval[INTERVAL_SIZE];
int offset = 0;

void setup() {
  Serial.begin(9600);
  if (!bmp.begin()) {
    Serial.print("No BMP sensor detected");
    while(1);
  }

  initRunningAvg();
}

void loop() {
  altitude = getAltitude();
  if (altitude != NO_RESULT) {
    avgAltitude = getRunningAvg(altitude);
    Serial.print(altitude);
    Serial.print(",");
    Serial.println(avgAltitude);
  }
}

// Populates all slots of interval buffer with an initial value
boolean initRunningAvg() {
  altitude = getAltitude();
  while (altitude == NO_RESULT) {
    altitude = getAltitude();
  }
  
  for (int i = 0; i < INTERVAL_SIZE; i++) {
      interval[i] = altitude;
  }
}

float getAltitude() {
  sensors_event_t event;
  bmp.getEvent(&event);

  if (event.pressure) {
    float temperature;
    bmp.getTemperature(&temperature);
    return bmp.pressureToAltitude(seaLevelPressure,event.pressure,temperature);
  }
  return NO_RESULT;
}

float getRunningAvg(float newval) {
  interval[offset] = newval;
  float sum = 0;
  for (int i = 0; i < INTERVAL_SIZE; i++) {
    sum += interval[i];
  }

  offset = (offset+1)%INTERVAL_SIZE;
  return sum/(float)INTERVAL_SIZE;
}

