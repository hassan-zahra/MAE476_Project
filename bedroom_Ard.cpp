#include <Arduino.h>
#include <math.h>

const int therm = A0;    //thermistor pin
const int LDR = A1;      //photo resistor pin
const int light = 3;     //LED pin
const int fan = 10;      //motor(fan) pin
int motor = 0;           //motor PWM value

//controls from Processing
int targetTempF = 70;  
int targetLight = 100;

//function declarations
void readPC();
float thermTemp();

//photo resistor bounds (change expirementally based on setup)
int lightUpper = 500;
int lightLower = 50;
//add Serial.println(analogRead(A1)) to the bottom of loop()
//to determine good bounds for your setup

void setup() {
  Serial.begin(9600);
  //Set the light and fan as outputs
  pinMode(fan, OUTPUT);
  pinMode(light, OUTPUT);
}

void loop() {
  readPC(); //reads serial communication

  //read the photo resistor value then modify the brightness of the LED
  int lightLDR = analogRead(LDR);
  float strength = targetLight / 100.0;
  float bright = map(lightLDR, lightLower, lightUpper, 255, 0);
  int brightI = (int)(bright*strength);
  brightI = constrain(brightI,0,255);
  analogWrite(light, brightI); 

  //read the thermistor value then modify the fan strength
  float currTemp = thermTemp();
  float error = currTemp - targetTempF;
  if (error > 0.5 && error < 4.0) {
    motor = 100; //lower speed setting for desired temp within 4 degrees
  }
  else if (error > 4.0) {
    motor = 250; //higher speed setting when room temp exceeds 4 degrees above desired
  }
  else {
    motor = 0; //turn off when at desired temperature
  }

  analogWrite(fan, motor);

  delay(50);
}

void readPC(){ //read serial communication
  if (!Serial.available()){ //checks if serial communication exists
    return; //ands ends if it does not
  }

  //I learned Java String methods below from w3schools
  //https://www.w3schools.com/jsref/jsref_trim_string.asp
  //https://www.w3schools.com/java/ref_string_length.asp
  String in = Serial.readStringUntil('\n'); //input from Processing
  in.trim(); //remove whitespace
  if (in.length() == 0) {
  return; //ends if the input is null
  }

  if (in.startsWith("T,")){
    targetTempF = in.substring(2).toInt();
  }
  if (in.startsWith("L,")){
    targetLight = in.substring(2).toInt();
  }
}

float thermTemp(){ //temperature of thermistor in F
  int thermADC = analogRead(therm);
  float thermV = thermADC * 5.0/1023.0;
  float Rf = 10000.0; //resistor in circuit is 10K Ohms
  float Rtherm = (5.0 / thermV - 1.0) * Rf; //voltage divider equation
  //R0, T0, beta come from thermistor specs
  float R0 = 10000.0; //thermistor resistance at T0
  float T0 = 298.15; //reference temp
  float beta = 3950.0; //beta value of thermistor

  //beta form of Steinhart-Hart equation
  //calculates temp and converts to Celsius
  float tempC = 1.0 / ((1.0/T0) + (1.0/beta)*log(Rtherm/R0)) - 273.15; 

  //returns value in Fahrenheit
  return (tempC*9.0/5.0)+32;
}