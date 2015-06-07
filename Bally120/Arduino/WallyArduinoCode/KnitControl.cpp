/* KnitControl.cpp
 * makes the machine go!
 */

#include "KnitControl.h"
//#include "Application.h"

const int KnitControl::movementVect[] = {54,54,53,54};  

KnitControl::KnitControl(){
  mm =  new MotorMgr();
  sm = new ServoMgr();
  homed = false;
  curPos = -1;
  dir = true;
  needleMode=false;
  stepCycleIndex = 0;
  lastStepsToDo = stepsToDo = 0;
}

String KnitControl::run(char c) {
  String res = "nop";
  bool processed = false;
  switch (c){
    case ' ':
      processed=true;
      break;
    case 'b':      // toggle BACK servos
    case 'B':
      processed = true;
      sm->setFB(false,ServoMgr::Toggle);
      res = "Toggling BACK servos.";
      break;
    case 'f':      // toggle FRONT servos
    case 'F':
      processed = true;
      sm->setFB(true,ServoMgr::Toggle);
      res = "Toggling FRONT servos.";
      break;
    case 'G':
    case 'g':      // just go until we can go no more
      processed = true;
      if (homed){
        stepsToDo=-1;
        lastStepsToDo=0;
        res = "Goiing for it!";
      }
      else{
        res = "Better HOME first...";
      }
      break;
    case 'h':      // set the current position as home
      setHome();
      processed = true;
      res = "Homed!";
      break;
    case 'l':
    case 'L':     // take a step left
      processed = true;
      setDir(true);
      res = "Direction:  LEFT!";
      break;
    case 'n':     // chang to needle mode, i.e. numbers entered refer to needles
    case 'N':
      processed = true;
      needleMode = true;
      res = "Needle Movement Mode activited!";
      break;
    case 'p':    // display curren position
    case 'P':
      processed = true;
      res = "Current Position: " + String(curPos);
      break;
    case 'r':     // take one step right
    case 'R':
      processed = true;
      setDir(false);
      res = "Direction: RIGHT!";
      break;
    case 's':     // switch tostep mode: numbers entered refer to steps
    case 'S':
      processed = true;
      needleMode = false;
      res = "Step Movement Mode activited!";
      break;
    case 't':      // toggle TOP servo
    case 'T':
      processed = true;
      sm->toggle(ServoMgr::Top);
      res = "Toggling TOP servo.";
      break;
    case 'v':      // Visualize status
    case 'V':
      processed = true;      
      res = getStatus();
      break;
    case 'z':      // all servos OUT 
    case 'Z':
      processed = true;
      for (int i=0;i<ServoMgr::nbServos;i++){
        sm->set(i,false);
      }
      res = "Servos set to OUT.";
      break;
  }
  if (!processed){
    if (c >= '0' && c <= '9'){
      int nbSteps = ((c -'0') * 5) + 1;
      if (needleMode){
        moveNeedles(nbSteps);
      }
      else{
        moveSteps(nbSteps);
      }
    }
  }
  return res;
}

String KnitControl::getStatus(){
  String  homedS = String("H: ") + String(homed ? "T" :"F");
  String  curPosS = String(" P: ") + String(curPos);
  String  dirS = String(" D: ") + String(dir ? "L" : "R");
  String  needleModeS = String(" N: ") + String(needleMode ? "T" : "F");
  String  stepCycleIndexS = String(" C: ") + String(stepCycleIndex);
  String  servoS = String(" S: ") + sm->getStatus();
  String res = homedS + curPosS + dirS + needleModeS + stepCycleIndexS + servoS;
  return res;
}

int KnitControl::nextNbSteps(){
  int ret = movementVect[stepCycleIndex];
  stepCycleIndex  = (stepCycleIndex+1) % stepVecLen;
  return ret;
}
  
void KnitControl::setHome(){
  homed = true;
  curPos = 0;
  lastStepsToDo = stepsToDo = 0; 
}

void KnitControl::setDir(bool d){
  dir = d;
  mm->dir(d);
}

void KnitControl::moveSteps(int nbSteps){
  stepsToDo += nbSteps;
}

void KnitControl::moveNeedles(int nbNeedles){
  for (int i = 0; i<nbNeedles; i++){
    stepsToDo += nextNbSteps();
  }
}

String KnitControl::incKnit(){
  String res = ""; 
  if (!stepsToDo){
    if (lastStepsToDo){
      res  ="Done Stepping.";
      lastStepsToDo = 0;
    }
  }
  else {
    lastStepsToDo = stepsToDo;
    if (dir){  // going left
      if(curPos < maxSteps){  // it's ok to take a step!
        mm->oneStep();
        curPos++;
        stepsToDo--;
      }
      else { // can't go left
        lastStepsToDo=stepsToDo = 0;
        res = "LEFT Limit!";
      }
    }
    else { // going right
      if(curPos > 0){  // it's ok to take a step!
        mm->oneStep();
        curPos--;
        stepsToDo--;
      }
      else{
        lastStepsToDo=stepsToDo = 0;
        res = "RIGHT Limit!";
      }
    }
  }
  return res;
}

