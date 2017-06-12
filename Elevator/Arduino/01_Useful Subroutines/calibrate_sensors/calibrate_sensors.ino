// 10.7.16
//
// Calibration
//
// Sequence to calibrate the accelerometer and pressure sensor
// Press button on pin 9 to print min & max ranges
// Press button on pin 8 to reset and recalibrate

#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BMP085_U.h>
#include <SparkFun_ADXL345.h>   

ADXL345 adxl = ADXL345(10);           
Adafruit_BMP085_Unified bmp = Adafruit_BMP085_Unified(10085); 
float groundLevelPressure;
float stationaryZ;

float minPressure, maxPressure, minAltitude, maxAltitude, minZAccel, maxZAccel;

int calibratePin = 8;
int rangePin = 9;
unsigned long lastButtonPress;
int buttonTimeout = 500;

///////////////////////////////////////////////////////////

void setup() {
  Serial.begin(9600);

  initLights();
  initButtons();
  initSensors();
  calibrateSensors();
  resetMinMax();

  lastButtonPress = millis();
}

void loop() {
  float pressure = getPressure();
  float zAccel = getZAccel();
  float altitude = getAltitude(pressure);

  maxAltitude = max(maxAltitude, altitude);
  minAltitude = min(minAltitude, altitude);
//  maxPressure = max(maxPressure, pressure);
//  minPressure = min(minPressure, pressure);
  maxZAccel = max(maxZAccel, zAccel);
  minZAccel = min(minZAccel, zAccel);

  unsigned long currentTime = millis();
  if (digitalRead(rangePin) == LOW && currentTime - lastButtonPress > buttonTimeout) {
    printMinMax();
    lastButtonPress = currentTime;
  } else if (digitalRead(calibratePin) == LOW && currentTime - lastButtonPress > buttonTimeout) {
    calibrateSensors();
    resetMinMax();
    lastButtonPress = currentTime;
  }
}

///////////////////////////////////////////////////////////

void initSensors() {
  adxl.powerOn();
  adxl.setRangeSetting(8);
  adxl.setSpiBit(0);
  if (!bmp.begin()) {
    Serial.print("No BMP sensor detected");
    while(1);
  }
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

void resetMinMax() {
  maxAltitude = 1.98;
  minAltitude = -1.33;
  maxPressure = 0;
  minPressure = 2000;
  maxZAccel = -200;
  minZAccel = 200;
}

void calibrateSensors() {
  Serial.println("Calibrating Sensors...");
  setAllLights(HIGH);
  
  int frames = 200;
  double totalPressure = 0;
  double totalZAccel = 0;

  for (int i = 0; i < frames; i++) {
    float pressure = getPressure();
    float zAccel = getZAccel();

    totalPressure += pressure;
    totalZAccel += zAccel;
  }

  groundLevelPressure = totalPressure/frames;
  stationaryZ = totalZAccel/frames;
  float groundAltitude = getAltitude(groundLevelPressure);
  
  setAllLights(LOW);
  printValue("Ground Level Pressure", groundLevelPressure);
  printValue("Ground Altitude", groundAltitude);
  printValue("Stationary Z Accel", stationaryZ);
}

void printMinMax() {
  float minAltitude = getAltitude(maxPressure);
  float maxAltitude = getAltitude(minPressure);
  
  printValue("Min Pressure", minPressure);
  printValue("Max Pressure", maxPressure);
  printValue("Min Altitude", minAltitude);
  printValue("Max Altitude", maxAltitude);
  printValue("Min Z Accel", minZAccel);
  printValue("Max Z Accel", maxZAccel);  
}

void printValue(String label, float val) {
  Serial.print(label);
  Serial.print(": ");
  Serial.println(val);
}

float getPressure() {
  sensors_event_t event;
  bmp.getEvent(&event);
  while(!event.pressure)
    bmp.getEvent(&event);
  return event.pressure;
}

float getAltitude(float pressure) {
  float temperature;
  bmp.getTemperature(&temperature);
  return bmp.pressureToAltitude(groundLevelPressure, pressure, temperature);
}

float getZAccel() {
  int x, y, z;
  adxl.readAccel(&x, &y, &z);
  return z;
}

