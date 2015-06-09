/*
Wally Arduino Code - We'll see if it ever works!
 */
#include <Arduino.h>
#include <Servo.h>
#include "CommunicationMgr.h"
#include "Config.h"
#include "ConnectionMgr.h"
#include "KnitControl.h"
#include "MotorMgr.h"
#include "ServoMgr.h"

ConnectionMgr     *cm;
CommunicationMgr  *coms;
KnitControl       *kc;

void setup(){
  // create a connection manager
  cm = new ConnectionMgr();
  coms = new CommunicationMgr();
  kc =  new KnitControl();
}

void loop(){
  if (cm->establishConnection()){
    coms->mssg(kc->run(coms->process()),true);
    coms->mssg(kc->incKnit(),true);
  }
}

