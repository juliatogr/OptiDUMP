#include <Grove_LED_Bar.h>
#include <SoftwareSerial.h>

// Pin values + Led bar creation
const int lightSensorPin = A0;
const int distSensorPin = A2;
Grove_LED_Bar bar(13,12, true); // Clock pin, Data pin, Orientation

// Variables where we are going to save all received info by the sensors
int lightVal = 0;
int distVal = 0;

// Thresholds to take into account
int lightTh = 50;
int distTh = 16;

// Boolean variables to know if each dumpster is full
bool lightIsFull = false;
bool distIsFull = false;

SoftwareSerial bt(10, 11); //RX/TX (inverse on bluetooth)

void setup() {
  bar.begin();
  pinMode(lightSensorPin, INPUT);
  pinMode(distSensorPin, INPUT);
  bt.begin(9600);
}

void loop() {

  bar.setLevel(8);                           // Turn on led bar
  lightVal = analogRead(lightSensorPin);      // Light sensor data
  distVal = analogRead(distSensorPin);        // Distance sensor data

  // check if the dumpster with light sensor is full
  if (lightVal < lightTh){
    lightIsFull = true;
  } else{
    lightIsFull = false;
  }

  // check if the dumpster with distance sensor is full
  if (distVal < distTh){
    distIsFull = true;
  } else{
    distIsFull = false;
  }

  // Send data
  bt.print("|");        //Data Separator
  bt.print(lightIsFull);
  bt.print(distIsFull);
  delay(200);     // Take a time to get all data
}
