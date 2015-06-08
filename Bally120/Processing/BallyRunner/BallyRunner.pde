// BallyRunner.pde
import processing.serial.*; 


////////////////////
/// ROWS TO KNIT Global variable
int nbRowsToKnit = 5;
////////////////////

////////////////////
///  Connection Globals
/// PORT NAME and BAUD RATE can be changed here if needed!
Serial myPort;                  // The serial port
boolean connectionEstablished = false,
        leonardoBoard = true;

char connectChar = '&';
String portName = "/dev/ttyACM1";
int     portDelay = 1000,
        baudRate = 9600,
        leonardoResetDelay = 10000;
////////////////////

//////////////////
// Knitting globals
boolean homed= false,
        awayed = false,
        rightEnd = false,
        automatedKnittingInitialized = false,
        atEnd = false,
        nStepping = false;
        
char knittingDir = ' ';

int commandDelay =  100,
    nbRowsRemaining =  0;  
//////////////////


//////////////////
/// Display Globals
String aWords[],
       currentPos = "",
       connectTex = "";
       
int msgX[], 
    msgY[],
    posX = 400,
    posY = 0,
    cX = 400,
    cY = 20,
    nbMsgs = 20;
 
boolean firstPass = true;
//////////////////

void setup() {  
  size(640,480);
  // set up the display
  initTextVecs(); 

  // Create the font
  textFont(createFont("Georgia", 36));
  textSize(14);  
}

void draw() {
  // this clears the display so that at each loop we have a fresh canvas
  background(0);
  // init post-setup
  if (firstPass){
    firstLoopSetup();
  }
  else{
    // first, connect to the arduino, or if already connected, skip
    if (!connectionEstablished){
      establishConnection();
    }
    // Display the text lines
    for (int i=0 ; i<nbMsgs;i++){
       text(aWords[i], msgX[i],msgY[i]);
    }
    // display the last known carriage position
    text(currentPos,posX,posY);
    // display connection status
    text(connectTex,cX,cY);
    // if automated stepping, i.e. automatically knitting rows, then take an nStep , 
    // i.e. increment the knitting loop
    if (nStepping){
      nStep();
    }
  }
}


