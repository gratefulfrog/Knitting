/* ConnectionMgr.cpp
 * maintains a single serial connection
 */
 
#include "ConnectionMgr.h"

ConnectionMgr::ConnectionMgr(){
  // create an instance
  connected = false;
  Serial.begin(BAUD_RATE);
  while (!Serial);
}


// as soon as we have read something on the port, we are connected.
// this routine should be called until it returns TRUE.
bool ConnectionMgr::establishConnection(){
  // try to establish a connection, return true if successful, false otherwise
  if (!connected){
    if (Serial.available() > 0) {
      Serial.println(connectChar);   // send an initial string
      connected = true;
    }
  }
  return connected;
}

