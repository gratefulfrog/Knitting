/* ConnectionMgr.cpp
 * maintains a single serial connection
 */
 
#include "ConnectionMgr.h"
//#include "Application.h"

ConnectionMgr::ConnectionMgr(){
  // create an instance
  connected = false;
  Serial.begin(BAUD_RATE);
  while (!Serial);
}

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

