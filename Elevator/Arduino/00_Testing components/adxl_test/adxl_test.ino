// 9.19.16
// 
// Reads from accelerometer and prints out <x, y, z> values to serial
 
#include <SparkFun_ADXL345.h>         

ADXL345 adxl = ADXL345(10);           // SPI communication, specifies CS_PIN

void setup() {
  Serial.begin(9600);                 
  adxl.powerOn();                     
  adxl.setRangeSetting(8);            // could be 2g, 4g, 8g, 16g, lower range = more sensitive
  adxl.setSpiBit(0);                  // 4 wire SPI mode
}

void loop() {
  int x,y,z;   
  adxl.readAccel(&x, &y, &z);        
  Serial.print(x);
  Serial.print(',');
  Serial.print(y);
  Serial.print(',');
  Serial.println(z);
}
