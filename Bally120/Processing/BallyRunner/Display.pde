// Display stuff

// allocated memory and initialize the x,y positions
// for the text display
void   initTextVecs(){ 
  aWords = new String[nbMsgs];
  aWords[0] ="";
  msgX =  new int[nbMsgs];
  msgY =  new int[nbMsgs];
  msgX[0] = 10;
  msgY[0] = 20;
  for (int i = 1 ; i< nbMsgs; i++){
    msgX[i]= msgX[0];
    msgY[i]= msgY[i-1] + msgY[0];
    aWords[i] = "";
  }
  posY = msgY[nbMsgs-1];
}

// move all the texts down one index in the text vector, losing the [0]th element,
// then take the new string and put it at the top, i.e. displayed at the lowest position on the screen 
void updateMesageDisplay(String s){
  for (int i = 0 ; i< nbMsgs-1;i++){
    aWords[i] = aWords[i+1];
  }
  aWords[nbMsgs-1] = s;
  if (s.indexOf("Limit!")>0){
    atEnd = true;
  }
}

// take incoming messages from the Arduino, do any parsing needed, and update the display texts
void processIncoming(String s){
  print(s);  // to the stdout window
  // check if it's a current position message and if so update the currentPos text
  updateMesageDisplay(s);
  if (null != match(s,"Curr")) {
    currentPos = s;
  }
}

void firstLoopSetup(){
  // List all the available serial ports to the message window
  // this is usefull to debug connection issues on NON LINUX machines
  println(Serial.list());

  if (leonardoBoard){
    leonardoReset();
      println("Leonardo Reset! letting port close... " + str(leonardoResetDelay/1000) + " seconds");  

    updateMesageDisplay("Leonardo Reset! letting port close...");
    daly(leonardoResetDelay);
    updateMesageDisplay("Termporizing done!");
    println("Termporizing done!");
  }
  
// local variabl just for printing
  boolean portOpen = false;
  myPort = new Serial(this, portName, baudRate);
  if(myPort !=null){
    portOpen=true;
  }
  println("Port opened: " + portOpen);
  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
  firstPass = false;
}
