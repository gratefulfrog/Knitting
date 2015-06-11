/* ServoMgr.h
 * maintains the servo positions
 */

#ifndef SERVOMGR_H
#define SERVOMGR_H

#include <Arduino.h>
#include "Config.h"
#include <Servo.h> 

#define SERVO_T  (0)
#define SERVO_FB (1)
#define SERVO_BB (2)
#define SERVO_FT (3)
#define SERVO_BT (4)

class ServoMgr {
  private:
    Servo  servoFB,   // front needle servo
           servoFT,   // front yarn servo
           servoBB,   // back needle servo
           servoBT,   // back yarn servo
           servoT;    // added by Bob 2015 04 01 for top servo

    // note order of servos in vect to allow easy processing
    // 0 = Top
    // 1,3 Front
    // 2,4 Back
    Servo* servoVec[5];
    static const int inOutVec[][5];
    
    // in is true
    bool* stateVec;
    static const int dirKnittingServoVec[][2];

  public:
    static const int nbServos = 5;
    static const int Toggle = -1,
                     In =  0,
                     Out = 1,
                     Top =0,
                     FB = 1,
                     BB = 2,
                     FT = 3,
                     BT = 4;
                     
    ServoMgr();
    String getStatus();
    void toggle (int servoIndex); 
    void set (int servoIndex, bool in);
    void setFB(bool fb, int val);  // sets front or back knitting, to Toggle, In or Out 
    void setServos2Knit(bool leftB);
  
};

#endif


