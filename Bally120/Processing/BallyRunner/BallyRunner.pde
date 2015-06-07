// BallyRunner.pde
import processing.serial.*; 

int nbRowsToKnit = 5;


Serial myPort;                  // The serial port
boolean connectionEstablished = false,
        leonardoBoard = true;

char connectChar = '&';
String aWords[],
       currentPos = "",
       connectTex = "";
       
int msgX[], 
    msgY[],
    posX = 300,
    posY = 0,
    cX = 300,
    cY = 20,
    nbMsgs = 20,
    portDelay = 1000;

boolean homed= false,
        rightEnd = false,
        automatedKnittingInitialized = false,
        atEnd = false,
        nStepping = false;
        
char knittingDir = ' ';

int commandDelay =  100,
    nbRowsRemaining =  0;  

void daly(int ms){
  // delay ms milliseconds
  int now = millis();
  while(millis()-now < ms);
}

void leonardoReset(){
  Serial tempPort = new Serial(this, "/dev/ttyACM0", 1200);
  daly(portDelay);
  tempPort.stop();
  println("Leonardo Reset!");
}

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
  
void setup() {  
  size(640,480);
  if (leonardoBoard){
    leonardoReset();
  }
  initTextVecs(); 
 
  // Create the font
  textFont(createFont("Georgia", 36));
  textSize(14);
  
  // List all the available serial ports
  println(Serial.list());

  boolean portOpen = false;
  myPort = new Serial(this, "/dev/ttyACM0", 9600);
  if(myPort !=null){
    portOpen=true;
  }
  println("Port opened: " + portOpen);
  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
}

void draw() {
  background(0);
  if (!connectionEstablished){
    establishConnection();
  }
  for (int i=0 ; i<nbMsgs;i++){
     text(aWords[i], msgX[i],msgY[i]);
  }
  text(currentPos,posX,posY);
  text(connectTex,cX,cY);
  if (nStepping){
    nStep();
  }
}

void establishConnection(){
  connectTex = "Trying to establish connection...";
  println(connectTex+ " sending:" + connectChar);
  myPort.write(connectChar);  
}
    
void serialEvent(Serial myPort) {
  String incoming = myPort.readStringUntil('\n');
  if (connectionEstablished){
    processIncoming(incoming);
  }
  else{
    connectTex  = "Connection Established!";
    println(connectTex);
    connectionEstablished = true;
  }
}

void updateMesageDisplay(String s){
  for (int i = 0 ; i< nbMsgs-1;i++){
    aWords[i] = aWords[i+1];
  }
  aWords[nbMsgs-1] = s;
  if (s.indexOf("Limit!")>0){
    atEnd = true;
  }
}

void processIncoming(String s){
  print(s);  // to the stdout window
  // check if it's a current position message and if so update the currentPos text
  updateMesageDisplay(s);
  if (null != match(s,"Curr")) {
    currentPos = s;
  }
}
  
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
    if (key == 'h' || key == 'H'){
      homed = true;
    }
    else if (key == 'r' || key == 'R' || key == 'l' || key == 'L') {
      knittingDir =  key;
    }
    else if (key == 'i' || key == 'I'){
      initKnitSequence();
    }
    else if (key == 'x' || key == 'X'){
      knitOneRow();
    }
    else if (key == 'e' || key == 'E'){
      nbRowsRemaining = nbRowsToKnit;
      nStepping=true;
    }
    else if (key == 'a' || key == 'A'){
      nbRowsRemaining = 0;
      nStepping=false;
    }
  }
  else if (key == CODED) {
     if (keyCode == LEFT) {
       got = "LEFT";
       myPort.write('L');
     } else if (keyCode == RIGHT) {
       got = "RIGHT";
       myPort.write('R');
     }
  }
  println("Captured key: " + got);
}

void initKnitSequence(){
  // check for homed, then set to left end
  if (!homed){
    updateMesageDisplay("Please Home first!");
  }
  else{
    myPort.write('z');  // zero the servos
    daly(commandDelay);
    myPort.write('b');  // toggle the back servos IN, since there will be a toggle at the knitRow command!
    daly(commandDelay);
    myPort.write('t');  // toggle the TOP servo IN!
    daly(commandDelay);
    if (!rightEnd){
      setKnittingDir('R');
      goToEnd();
      rightEnd = true;
    }
    automatedKnittingInitialized  = true;
  }
}

void setKnittingDir(char d){
  knittingDir = d;
  myPort.write(d);
  daly(commandDelay);
}
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

void toggleKnittingServos(){
  myPort.write('f');
  daly(commandDelay);
  myPort.write('b');
  daly(commandDelay);
}

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
  
