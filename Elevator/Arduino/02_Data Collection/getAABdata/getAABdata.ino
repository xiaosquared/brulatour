// 10.6.16
//
// Get AAB Data
//
// Plots accelerometer Z, Altitude, button press times

#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BMP085_U.h>
#include <SparkFun_ADXL345.h>         

ADXL345 adxl = ADXL345(10);           
Adafruit_BMP085_Unified bmp = Adafruit_BMP085_Unified(10085); 
float seaLevelPressure = 1031.98;
const float NO_RESULT = -9999;

const int GREEN = 6;
const int RED = 7;
const int YELLOW = 8;
const int BLUE = 9;

unsigned long currentTime;
int greenState, redState, yellowState, blueState;
int greenPrev, redPrev, yellowPrev, bluePrev;
unsigned long greenTime, redTime, yellowTime, blueTime;
int timeOut = 500;

void setup() {
  Serial.begin(9600);
  adxl.powerOn();
  adxl.setRangeSetting(8);            // could be 2g, 4g, 8g, 16g, lower range = more sensitive
  adxl.setSpiBit(0);                  // 4 wire SPI mode
  if (!bmp.begin()) {
    Serial.print("No BMP sensor detected");
    while(1);
  }
}

void loop() {
  int zAccel = getZAccel();
  float altitude = getAltitude();
  Serial.print(zAccel);
  Serial.print(",");
  Serial.print(altitude);
  detectButtons();
}

void initButtons() {
  for (int i = GREEN; i <= BLUE; i++) {
    pinMode(i, INPUT);
  }
  
  greenPrev = HIGH;
  redPrev = HIGH;
  yellowPrev = HIGH;
  bluePrev = HIGH;

  greenTime = millis();
  redTime = greenTime;
  yellowTime = greenTime;
  blueTime = greenTime;  
}

void detectButtons(){
  greenState = digitalRead(GREEN);
  redState = digitalRead(RED);
  yellowState = digitalRead(YELLOW);
  blueState = digitalRead(BLUE);

  currentTime = millis();
  
  if (greenState == LOW && greenPrev == HIGH 
                        && currentTime - greenTime > timeOut) {
    greenTime = currentTime;
    Serial.print(",");
    Serial.print("E_START");
    Serial.print(",");
    Serial.println(greenTime);
  }
  else if (redState == LOW && redPrev == HIGH
                       && currentTime - redTime > timeOut) { 
    redTime = currentTime;                        
    Serial.print(",");                                              
    Serial.print("E_STOP");
    Serial.print(",");
    Serial.println(redTime);
  }
  else if (yellowState == LOW && yellowPrev == HIGH
                        && currentTime - yellowTime > timeOut) {
    yellowTime = currentTime;                          
    Serial.print(",");  
    Serial.print("D_OPEN");
    Serial.print(",");
    Serial.println(yellowTime);
  }
  else if (blueState == LOW && bluePrev == HIGH
                        && currentTime - blueTime > timeOut) {
    blueTime = currentTime;                          
    Serial.print(",");     
    Serial.print("D_CLOSE");
    Serial.print(",");
    Serial.println(blueTime);
  }
  else
    Serial.println("");
  greenPrev = greenState;
  redPrev = redState;
  yellowPrev = yellowState;
  bluePrev = blueState;
}

float getZAccel() {
  int x, y, z;
  adxl.readAccel(&x, &y, &z);
  return z;
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
