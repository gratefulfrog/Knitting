/* KnitControl.h
 * makes the machine go!
 */

#ifndef KNITCONTROL_H
#define KNITCONTROL_H

#include <Arduino.h>
#include "MotorMgr.h"
#include "ServoMgr.h"

#define STEPS_PER_REV (200)
#define MM_PER_REV    (40)
#define NB_NEEDLES    (60)
#define NEEDLE_PITCH  (8.6)
#define STEPSPERNEEDLE (43)

class MotorMgr;

class KnitControl {
  private:
    static const int // obsoelte movementVect[] ,
                     stepsPerRev    = STEPS_PER_REV,
                     mmPerRev       = MM_PER_REV,
                     nbNeedles      = NB_NEEDLES,
                     needlePitch    = NEEDLE_PITCH,
                     stepsPerNeedle = STEPSPERNEEDLE;  // 8.6 * 200/200
  
    bool awayed, // true if we have been awayed
         homed, // true if we have been homed
         dir,    // true is to the left
         needleMode; // tur if movement is by needles and not steps.

    int curPos,  // number of steps we have taken since home
        awayPos,  // number of steps to left end
        stepsToDo,  // number of steps outstanding
        lastStepsToDo; // and the same one iteration ago
    static const int maxSteps =  STEPSPERNEEDLE* nbNeedles + 2, // just to be sure we don't go crazy and over run the end  
                     minPos = -(STEPSPERNEEDLE* nbNeedles + 2);

  private:
    int nextNbSteps();  // tells how many steps to take to go to next needle
    MotorMgr *mm;
    ServoMgr *sm;
    
  public:
    KnitControl();
    String run(char);
    String getStatus();
    void setHome();
    void setAway();
    void setDir(bool d);
    void moveSteps(int nbSteps);
    void moveNeedles(int nbNeedles);
    String incKnit();
};

#endif

