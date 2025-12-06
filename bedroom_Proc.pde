//UI for the temperature and light controls
//Sends commands to the Arduino over Serial

import processing.serial.*;
Serial arduino;

//thermostat setup
int targetTempF = 70;  // starting setpoint
int minTempF = 60;
int maxTempF = 80;

//light setup
int targetLight = 100;
StringList light = new StringList();


//button size
float buttonWidth = 120;
float buttonHeight = 80;

//initialize temperature button location
float upTempX;
float upTempY;
float downTempX;
float downTempY;

//initialize light button location
float upLightX;
float upLightY;
float downLightX;
float downLightY;


void setup() {
  //add light levels
  light.append("OFF");
  light.append("VERY LOW");
  light.append("LOW");
  light.append("MEDIUM");
  light.append("HIGH");
  
  //create window
  size(600, 400);
  textAlign(CENTER, CENTER);
  textFont(createFont("Arial", 32));

  //position temp buttons
  upTempX = width/4 - buttonWidth/2;
  upTempY = height/2 - 120;
  downTempX = upTempX;
  downTempY = height/2 + 40;

  //position light buttons
  upLightX = width*3/4 - buttonWidth/2;
  upLightY = height/2 - 120;
  downLightX = upLightX;
  downLightY = height/2 + 40;
  
  //connect to  Arduino
  println("ports:");
  println(Serial.list());
  String portName = Serial.list()[2]; //replace with whichever one Arduino is connected to
  arduino = new Serial(this, portName, 9600);
}

void draw() {
  background(255);

  //Temp UI
  drawButton(upTempX, upTempY, buttonWidth, buttonHeight, true);
  textSize(40);
  text(targetTempF + "°F", width/4, height/2);  
  drawButton(downTempX, downTempY, buttonWidth, buttonHeight, false);
  textSize(20);
  text("Temperature", width/4, upTempY - 20);
  
  //Light UI
  drawButton(upLightX, upLightY, buttonWidth, buttonHeight, true);
  textSize(40);
  text(light.get(targetLight/25), width*3/4, height/2);  
  drawButton(downLightX, downLightY, buttonWidth, buttonHeight, false);
  textSize(20);
  text("Light Level", width*3/4, upTempY - 20);
}


void drawButton(float x, float y, float w, float h, boolean upOrDown) {
  //button rectange
  fill(10, 90, 120);
  stroke(0);
  rect(x, y, w, h, 5);

  //arrow
  fill(0);
  noStroke();
  float tri_x = x + w/2;
  float tri_y = y + h/2;
  float size = h * 0.35;

  if (upOrDown) {
    // upward arrow
    triangle(tri_x, tri_y - size, tri_x - size, tri_y + size, tri_x + size, tri_y + size);
  }
  else {
    // downward arrow
    triangle(tri_x, tri_y + size, tri_x - size, tri_y - size, tri_x + size, tri_y - size);
  }
}

boolean within(float x, float y, float w, float h) {
  return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
}

void mousePressed() {
  // check if click is inside temp buttons
 if (within(upTempX,upTempY,buttonWidth,buttonHeight)) {
    targetTempF = constrain(targetTempF + 1, minTempF, maxTempF);
    sendTemp();
  }
  if (within(downTempX,downTempY,buttonWidth,buttonHeight)) {
      targetTempF = constrain(targetTempF - 1, minTempF, maxTempF);
    sendTemp();
  }
  
  // check if click is inside light buttons
 if (within(upLightX,upLightY,buttonWidth,buttonHeight)) {
    targetLight = constrain(targetLight + 25, 0, 100);
    sendLight();
  }
  if (within(downLightX,downLightY,buttonWidth,buttonHeight)) {
    targetLight = constrain(targetLight - 25, 0, 100);
    sendLight();
  }
}

//send temp value to arduino
void sendTemp() {
  if (arduino != null) {
    String sendT = "T," + targetTempF + "\n";
    arduino.write(sendT);
    println(sendT.trim()); //show what is sent
  }
}

//send light value to arduino
void sendLight() {
  if (arduino != null) {
    String sendL = "L," + targetLight + "\n";
    arduino.write(sendL);
    println(sendL.trim()); //show what is sent
  }
}
