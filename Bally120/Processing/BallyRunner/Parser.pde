// Parser for Keyboard interaction


// a very VERY simplistic keystroke parser:
// details:
//   q and Q : special, not sent to Arduino, quit the appliaction,
//   other alphanumeric keys : sent to arduino, then parsed for local use
//   LEFT and RIGHT arrow keys: consdered as 'L' and 'R', sent to Arduino and parsed for local use
void keyPressed() {
  // parse keys presses to send right stuff to Arduino
  if (key == 'q' || key == 'Q'){
    exit();
  }
  String got = "Ignored!";
  if ((key >= 'A' && key <= 'Z') || 
      (key >= 'a' && key <= 'z') || 
      (key >= '0' && key <= '9')){
    char c[] = {key, '\0'};
    got = new String(c);
    myPort.write(key);
    if (key == 'a' || key == 'A'){
      nbRowsRemaining = 0;
      nStepping=false;
    }
    else if (key == 'c' || key == 'C'){
      atEnd=false;
      homed =false;
      awayed =false;
      rightEnd = false;
      automatedKnittingInitialized = false;
      nStepping = false;
    }
    else if (key == 'e' || key == 'E'){
      nbRowsRemaining = nbRowsToKnit;
      nStepping=true;
    }
    else if (key == 'h' || key == 'H'){
      homed = true;
    }
    else if (key == 'i' || key == 'I'){
      initKnitSequence();
    }
    else if (key == 'x' || key == 'X'){
      knitOneRow();
    }
    else if (key == 'y' || key == 'Y'){
      if (homed){
        awayed = true;
      }
    }
    else if (key == 'r' || key == 'R' || key == 'l' || key == 'L') {
      knittingDir =  key;
    }
  }
  else if (key == CODED) {
     if (keyCode == LEFT) {
       got = "LEFT";
       myPort.write('L');
       knittingDir = 'L';
     } else if (keyCode == RIGHT) {
       got = "RIGHT";
       myPort.write('R');
       knittingDir = 'R';
     }
  }
  else if (key == '?'){
    got = "?";
    showHelp(helpStart);
    helpStart = ! helpStart;
  }
  println("Captured key: " + got);
}


