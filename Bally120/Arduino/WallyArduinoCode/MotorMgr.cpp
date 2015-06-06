/* MotorMgr.cpp
 * motor controls
 */

#include "MotorMgr.h"


MotorMgr::MotorMgr(){
  resetPin = resetP;
  dirPin =  dirP;
  stepPin = stepsP;
  pinMode(stepPin, OUTPUT); 
  pinMode(dirPin, OUTPUT); 
  pinMode(resetPin, OUTPUT);
  dir(true);
}


void MotorMgr::dir(bool d){ // true means left
  digitalWrite(resetPin, LOW);
  delay(DIRDELAY);
  digitalWrite(resetPin, HIGH);
  if (d){
      digitalWrite(dirPin, LOW);
  }
  else{
      digitalWrite(dirPin, HIGH);
  }
}

void MotorMgr::oneStep(){
  // take one step, in the current direction
  //  Serial.print("a step! ");
  digitalWrite(stepPin, HIGH);  
  digitalWrite(stepPin, LOW);   
  delayMicroseconds(STEPDELAY);
}


