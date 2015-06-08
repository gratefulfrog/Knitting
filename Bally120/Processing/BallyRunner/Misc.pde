// Misc functions


// a little delay function, argument is milliseconds.
// note: this is active waiting, so don't abuse it!
void daly(int ms){
  // delay ms milliseconds
  int now = millis();
  while(millis()-now < ms);
}

