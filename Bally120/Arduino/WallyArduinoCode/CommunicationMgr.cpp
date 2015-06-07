#include "CommunicationMgr.h"
#include "ConnectionMgr.h"
#include "KnitControl.h"
//#include "Application.h"

CommunicationMgr::CommunicationMgr(){
  inByte = ' ';
  msgCounter = 0;
}

bool CommunicationMgr::valid(byte b){
  return b != ConnectionMgr::connectChar;
}

char CommunicationMgr::process(){
  char res = ' ';
  if (Serial.available() > 0) {
    // get incoming byte:
    inByte = Serial.read();
    if (valid(inByte)){
      res = char(inByte);
      mssg(String(msgCounter++) + ':', false);
    }
  }
  return res;
}


void CommunicationMgr::mssg(String s, bool lf){
  if (s.equals("nop") || s.equals("")){
    return;
  }
  Serial.print(s);
  if (lf){
    Serial.println();
  }
}  
