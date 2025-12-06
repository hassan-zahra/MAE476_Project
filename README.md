**Smart Bedroom with Heat and Light Control** By Hassan Zahra

This project simulates a smart bedroom with a lighting element and cooling element that respond to information from a photo resistor (LDR) and a thermistor. The inspiration for this project came from my own bedroom which has bad temperature control so I wanted to make an ideal room setup.

**Software Overview**

The files for this build are:
- an Arduino file that controls the smart elements
- and a Processing file that sets up the UI and sets desired conditions

**Communication**

Processing communicates the desired values to Arduino over Serial using the format below.
* `T,<temp>` sends a temperature value in °F
* `L,<light%>` sends a value that scales the brightness of the LED

**Temperature**

1. The thermistor calculates the current temperature
2. Based on the values of the desired temperature, mode switch temp (MST), and tolerance (tol, MST > tol),
   * If the current temp exceeds the desired temp by a value between tol and MST, the fan is turned on at the low speed setting
   * If the current temp exceeds the desired temp by a value greater than MST, the fan is set to the high setting
   * Otherwise the fan does not turn on.
   Note: though not labeled in the Arduino script, tol = 0.5 and MST = 4.0.

**Light**

1. The LDR measures the current brightness in the room.
2. This value is inversely mapped to a PWM value (The bounds for max/min intensity can be set by the user).
3. The light percentage value from Processing then scales the brightness and it is sent to the LED.

**Hardware Setup**

The hardware components are:
- cardboard box (or any other material)
- Arduino (I used the Arduino Uno)
- thermistor
- LDR
- jumper wires
- breadboard
- L293D
- Power supply module
- 9V DC power supply
- DC motor
- Fan Blade
- LED
- tape and hot glue (to affix components to the box)

Hardware Instructions:
Note: this setup assumes you are using a rectangular cardboard box. The top and bottom of this box will be the largest faces (usually where the flaps are), the left and right will be the smallest sides, and the front and back will be the longer sides.
1. Starting with the cardboard box, cut out the top flaps and one of the longer walls (which will be referred to as the front). Replace the top with a single piece of cardboard to make sure it is uniform
2. In the center of the top piece, poke out 2 holes near each other (this can be done using the end of a jumper wire) for the LED to be held. You may use hot glue to hold the LED to the ceiling of the room
3. In the back wall, poke out 2 sets of 2 holes in a similar fashion to the LED. One set should be near the bottom center and the other should be to the right of that. These will be where the LDR (center) and thermistor (right) should be held. Again, hot glue may be used to hold them in place.
4. On the left wall, cut out some ventilation strips near the bottom to allow air to circulate, then an exhaust flap on the top of the right wall.
5. Above the vents, create a cutout for the DC motor ensuring you leave enough space for the fan blades to not touch the ceiling.
6. For ease of use and stability, the Arduino and breadboard can be taped to the top of the box.

**Wiring setup**

Refer to the image below for the wiring diagram
<img width="1470" height="823" alt="Smart Bedroom Wiring Diagram" src="https://github.com/user-attachments/assets/6cba3280-4b49-4898-91d7-dbfeb85600e1" />

*Limitations*
- Most importantly, I am not aware of a viable heating element that would be safe in this setup so there is only a cooling system.
- There is also a concern with noise as when the temperature reading fluctuates above and below the desired temp, the motor can keep turning on and off.
- There is some required setup for the thresholds of the sensors which must be determined experimentally and can change for the same box in a different environment.
- The sensors only measure values at a single point which may mot be accurate for the whole space. For a small box this is not a big issue but is still present to some extent.
