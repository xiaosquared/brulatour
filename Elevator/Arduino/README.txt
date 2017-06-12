# README: Guide to Arduino 

## 00_Testing Components: 
    
    - Downloaded sample code for sensor use:
        - adafruit_pressure_test
        - adxl_test
        - altitude test
    - Buttons test - 10.5.16
        - Push to print to serial + timestamp
    - LED Test - 10.7.16
        - Cycle through blinking LED just to test connections


## 01_Useful Subroutines - sketches to figure out functions in bigger programs

    - Altitude avg - 10.5.16 
        - Detects altitude based on pressure sensor and running average of 10 values
    - Calibrate sensors - 10.7.16
        - Sequence to calibrate the accelerometer and pressure sensor	

## 02_Data Collection - prints sensor and temporal data about elevator (to be analyzed by Python scripts)

    - Calibrate floor times - 10.17.16
        - Computes time between floors, prints to serial
    - Get AAB Data - 10.6.16
        - Plot accelerometer Z, Altitude, button press times

## 03_Older Attempts - programs that try to detect elevator movement but have problems

    - Going Up test - 9.19.16
        - Prints out state of movement based on Z acceleration (lifting up, continuing up, slowing up, stopped)
        - Also prints out how long it takes each time going up

    - Up Down v0 - 9.20.16
	- Prints out "UP!" when elevator starts upward acceleration
        - "DOWN!" when elevator starts downward acceleration

    - Up Down v1 - 9.20.16
        - Prints GOING UP, GOING DOWN, REST
        - Also prints out how long it takes each time going up

## 04_Best Efforts Oct 2016 - Working programs for the circuit I made

    - Up Down v2 - 10.11.16
        - Detects when elevator is going UP/DOWN and turns on LEDs

    - Up Down v3 - 10.17.16
        - Detects when elevator is going up or down and turns on LEDs
        - Turns on a second LED if going up 2 floors






