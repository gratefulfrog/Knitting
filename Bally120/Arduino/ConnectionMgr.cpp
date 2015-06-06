/* ConnectionMgr.cpp
 * maintains a single serial connection
 */

#ifndef CONNECTIONMGR_H
#define CONNECTIONMGR_H

#include "ConnectionMgr.h"

ConnectionMgr::ConnectionMgr(){
  // create an instance
  Serial.begin(BAUD_RATE);
  while (!Serial);
}

bool ConnectionMgr::estblishConnection(){
  // try to establish a connection, return true if successful, false otherwise
  if (connected){
    if (Serial.available() > 0) {
      Serial.println(connectChar);   // send an initial string
      connected = true;
  }
  return connected;
}

  


