class note {
  String type; // Type of note (ie. whole, half)
  Boolean rest; // If its a note or a rest
  String sound; // Type of sound
  int startbeat; // Where the note starts (count each 8th)
  int duration; 

  // Constructor
  note(String t, Boolean r, String s, int sb, int d ) {
    this.type = t;
    this.rest = r;
    this.sound = s;
    this.startbeat = sb;
    this.duration = d;
  }
  
  void drawImage(int x, int y, float factornotedisplay) {
    if (rest) { // Type of image for rests...
      if (type.equals("Eighth")) {
        image(eighthrest, x-5, y+7, quarterrest.width / (1.5*factornotedisplay), quarterrest.height / (1.5*factornotedisplay));
      } else if (type.equals("Quarter")) {
        image(quarterrest, x-5, y, quarterrest.width / factornotedisplay, quarterrest.height / factornotedisplay);
      } else if (type.equals("Half")) {
        image(halfrest, x+10, y, halfnote.width / (0.8*factornotedisplay), halfnote.height / factornotedisplay);
      } else if (type.equals("Whole")) {
        image(wholerest, x+10, y, wholenote.width / (0.8*factornotedisplay), wholenote.height / (factornotedisplay));
      }
    } else { // Type of image for notes
      if (type.equals("Eighth")) {
        image(eighthnote, x-5, y, eighthnote.width / factornotedisplay, eighthnote.height / factornotedisplay);
      } else if (type.equals("Quarter")) {
        image(quarternote, x-5, y, quarternote.width / factornotedisplay, quarternote.height / factornotedisplay);
      } else if (type.equals("Half")) {
        image(halfnote, x-5, y, halfnote.width / factornotedisplay, halfnote.height / factornotedisplay);
      } else if (type.equals("Whole")) {
        image(wholenote, x, y, wholenote.width / (1.5*factornotedisplay), wholenote.height / (1.5*factornotedisplay));
      }
    }
  }
}
