/* MotorMgr.h
 * motor controls
 */

#ifndef MOTORMGR_H
#define MOTORMGR_H

#include <Arduino.h>
#include "Config.h"

#define DIRDELAY (100)     # miliseconds
#define STEPDELAY (1000)   #microseconds

class MotorMgr {

  private:
    int resetPin,
        dirPin,
        stepPin;
        
    void generalGo();      
    
  public:
    MotorMgr();
    void oneStep();
    void dir(bool); //true means left
};

#endif

