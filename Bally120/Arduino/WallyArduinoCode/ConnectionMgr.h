/* ConnectionMgr.h
 * maintains a single serial connection
 */

#ifndef CONNECTIONMGR_H
#define CONNECTIONMGR_H

#include <Arduino.h>

#define CONNECT_CHAR ('&')
#define BAUD_RATE (9600)

class ConnectionMgr {
private:
  bool connected;
public:
  static const char connectChar =  CONNECT_CHAR;
  
 public:
  ConnectionMgr();
  bool establishConnection();
  
};

#endif


