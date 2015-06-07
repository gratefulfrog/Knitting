/* ServoMgr.cpp
 * maintains the servo positions
 */

#include "ServoMgr.h"

// note order of servos in vect to allow easy processing
// 0 = Top
// 1,3 Front
// 2,4 Back 
const int ServoMgr::inOutVec[][5] = {{servoT_in,
                                      servoFB_in,
                                      servoBB_in,
                                      servoFT_in,
                                      servoBT_in},
                                     {servoT_out,
                                      servoFB_out,
                                      servoBB_out,
                                      servoFT_out,
                                      servoBT_out}};
                         
    
ServoMgr::ServoMgr(){
  stateVec = new bool[5];
  for (int i=0;i<5;i++){
    stateVec[i] =  false;
  }
  servoVec[0] = &servoT;
  servoVec[1] = &servoFB;
  servoVec[2] = &servoBB;
  servoVec[3] = &servoFT;
  servoVec[4] = &servoBT;
  servoFB.attach(pinServoFB);   // servo in the front needle bed selecting needles
  servoFT.attach(pinServoFT);   // servo in the front needle bed stopping the loops rising up
  servoBB.attach(pinServoBB);   // servo in the back needle bed selecting needles
  servoBT.attach(pinServoBT);   // servo in the back needle bed stopping the loops rising up
  servoT.attach(pinServoT);  
  // set all except to out,
  for (int i=1;i<nbServos;i++){
    set(i,false);
  }
  // set T to in
  set(0,true);
  
}

String ServoMgr::getStatus(){
  String res = "";
  for (int i = 0; i < nbServos; i++){
    res += String(stateVec[i]);
  }
  return res;
}

void ServoMgr::toggle (int servoIndex){
  set(servoIndex,!stateVec[servoIndex]);
}      

void ServoMgr::set (int servoIndex, bool in){
  //Serial.println("Set: " + String(servoIndex) + " to: " + String(in));
  int stateIndex = in ? 0 : 1;
  
  servoVec[servoIndex]->write(inOutVec[stateIndex][servoIndex]);
  delay(15);
  stateVec[servoIndex] = in;
}

void ServoMgr::setFB(bool fb, int val){  // fb is true if front servos are to be set to val
  int start = fb ? 1 : 2;
  for (int i = start; i<nbServos; i+=2){
    if (val == ServoMgr::Toggle){
      toggle(i);
    }
    else{
      set(i,(val == ServoMgr::In ? true : false));
    }
  }
}  

