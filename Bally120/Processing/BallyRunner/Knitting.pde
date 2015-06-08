// Knitting Functions

// Initialize variabls for automatic knitting of multiple rows
// This means:
// 1. check for homed, if not cancel
// 2. set all servos to out
// 3. set top servo to IN to engage the yarn carrier
// 4. go to the RIGJHT end
// 5. engage BACK servos because the knitting sequence starts as if it had just finished a
//    row to the right, the next row will toggle the front AND back servos!
void initKnitSequence(){
  // check for homed, then set to left end
  if (!homed){
    updateMesageDisplay("Please Home first!");
  }
  else{
    myPort.write('z');  // zero the servos
    daly(commandDelay);
    myPort.write('t');  // toggle the TOP servo IN!
    daly(commandDelay);
    if (!rightEnd){
      setKnittingDir('R');
      goToEnd();
      rightEnd = true;
    }
    myPort.write('b');  // toggle the back servos IN, since there will be a toggle at the knitRow command!
    daly(commandDelay);
    automatedKnittingInitialized  = true;
  }
}

// takes a char, sends it to the Arduino,
// no error checking, but it must be l, or L, or r or R !!
// this sets the current knitting direction
void setKnittingDir(char d){
  knittingDir = d;
  myPort.write(d);
  daly(commandDelay);
}

// Tell the arduino to go the end in the current direction
void goToEnd(){
  atEnd= false;
  myPort.write('g');
  daly(commandDelay);
  if (knittingDir == 'r'){
    rightEnd = true;
  }
  else{
    rightEnd =false;
  }
}

// inverts the state of the FRONT and BACK servos,
// does nothing to the TOP servo
void toggleKnittingServos(){
  myPort.write('f');
  daly(commandDelay);
  myPort.write('b');
  daly(commandDelay);
}


// knit a row, if initialized!
// checks to be sure automated knitting has been initailized!
void knitOneRow(){
  if(!automatedKnittingInitialized){
    updateMesageDisplay("Please Initialize Automated Knitting first!");
    return;
  }    
  // from current position, which is an end:
  // servos should be set from previous row and require toggling
  toggleKnittingServos();
   if (rightEnd){
     setKnittingDir('l');
   }
   else {
     setKnittingDir('r');
   }
   goToEnd();   
}


// increment the knititing loop
// this is called at each pass in the draw loop if we have started automated knitting
// sequence is:
// 1. If Arduino has not reported arriving at an end, then do nothing and return
// 2. If there are rows remaing to be knit,  
//       display a message, 
//       reset atEnd to false, 
//       knit one row
//    else there are no rows remaining:
//       display a message
//       turn off automated knitting (set nStepping to false)
void nStep(){
  if (!atEnd){
    return;
  }
  if (!automatedKnittingInitialized){
    updateMesageDisplay("Please Initialize Automated Knitting first!");
    nStepping = false;
    return;
  }
  if (nbRowsRemaining > 0){
    String plural = " rows ";
    if (nbRowsRemaining==1){
     plural =  " row ";
    }
    updateMesageDisplay(str(nbRowsRemaining--) + plural + "remaining...");
    atEnd= false;
    knitOneRow();
  }
  else{
    updateMesageDisplay("Knitting complete!");
    nStepping =  false;
  }
}
  
