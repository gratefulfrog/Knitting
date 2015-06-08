// Connection stuff

// By executing this function, the Leonardo will do a soft reset and run
// its setup code again, then start the loop
// For Arduino Uno's this is not necessary, but it doesn't hurt either.
void leonardoReset(){
  Serial tempPort = new Serial(this, portName, 1200);
  daly(portDelay);
  tempPort.stop();
}

// The Arduino is waiting to read something on the port,
// this routine will send a character,
// serialEvent handler below will be called when the Arduino replies.
// If it receives the very first Arduino reply, then the connection is established.
// This works *almost* all the time..
void establishConnection(){
  connectTex = "Trying to establish connection...";
  println(connectTex+ " sending:" + connectChar);
  myPort.write(connectChar);  
}

// after connection, all serial event data is passed to to the parser.    
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

