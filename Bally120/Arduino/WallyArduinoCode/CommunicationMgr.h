/* ConnectionMgr.h
 * maintains a single serial connection
 */

#ifndef COMMUNICATIONMGR_H
#define COMMUNICATIONMGR_H

#include <Arduino.h>

class CommunicationMgr {
  private:
    int msgCounter;
    byte inByte;
    bool valid(byte);
    
  public:
    CommunicationMgr();
    char process();  
    void mssg(String,bool);  // send something to the Serial port, true if add \n
};

#endif


