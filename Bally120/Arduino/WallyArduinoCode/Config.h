/* Config.h
 * 
 */

#ifndef CONFIG_H
#define CONFIG_H
          
//stepper pins
const int stepsP = A1;
const int dirP = A2; 
const int resetP = A0;


// servo pins
const int   pinServoFB = 7,   // servo in the front needle bed selecting needles
            pinServoFT = 8,   // servo in the front needle bed stopping the loops rising up
            pinServoBB = 9,   // servo in the back needle bed selecting needles
            pinServoBT = 10,   // servo in the back needle bed stopping the loops rising up
            // top servo, added by Bob 2015 04 01, not used anywhere else in the code;
            pinServoT = 11;  

// Servo limits
// These values were updated by Bob 2015 04 01 as a result of servo Callibration
const int servoFB_out = 100;  // up
const int servoFB_in = 75;    // down
const int servoFT_in = 70;    // down
const int servoFT_out = 110;  // up
const int servoBB_out = 100;  // 140;  // up
const int servoBB_in = 75;    // 80;   // down
const int servoBT_in = 70;    // down
const int servoBT_out = 120;  // up
const int servoT_in = 60;     //down
const int servoT_out = 155;   // up



#endif

