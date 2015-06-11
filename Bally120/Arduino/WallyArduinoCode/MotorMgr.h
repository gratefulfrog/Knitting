/* MotorMgr.h
 * motor controls
 */

#ifndef MOTORMGR_H
#define MOTORMGR_H

#include <Arduino.h>
#include "Config.h"

// miliseconds
#define DIRDELAY (100)

// microseconds
#define STEPDELAY (1000)

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

