String helpMsgs[] = {"0..9: take n*5 +1 steps/needles, in the current direction",
         "a/A: ABORT current movement!",
         "b/B: toggle the BACK servos",
         "c/C: clear home and away",
         "e/E: Automatically knit nbRowsToKnit rows",
         "f/F: toggle the FRONT servos",
         "g/G: goto end, in current direction",
         "h/H: set the current position as HOME",
         "i/I: Initialize automated knitting",
         "k/K: Set Servos for Knitting in current Direction",
         "l/L/<-: set direction to LEFT",
         "n/N: set Needle mode",
         "p/P: display current position in steps",
         "q/Q: Quit (the processing application)",
         "r/R/->: set direction to RIGHT",
         "s/S: set Step mode",
         "t/T: toggle the TOP servo",
         "v/V: Visualize current status",
         "x/X: eXecute 1 row of automated knitting",
         "---- type '?' again for more commands ----",
         "y/Y: set the current position as AWAY",
         "z/Z: set ALL SERVOS to OUT",
         "?: display this help message"};
         

void showHelp(boolean fromStart){
  int i = 0,
      end = nbMsgs;
  if (!fromStart){
      i = end;
      end = helpMsgs.length;
  }
  for (;i<end;i++){
    updateMesageDisplay(helpMsgs[i]);
  }
}  

