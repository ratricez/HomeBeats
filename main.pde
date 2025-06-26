/////////////////////////////////////////////////////////////////////////
///// Welcome to HomeBeats! Hope you have fun :P                 ////////
///// Coder: Elaine!                                             ////////
///// Disclaimer: The best sound is the computer ping in office  ////////
/////////////////////////////////////////////////////////////////////////
 
import g4p_controls.*;
import processing.sound.*;

ArrayList<Boolean> noteStates = new ArrayList<>(); // For the squares 
ArrayList<note> whichNote = new ArrayList<>(); // Since each spot (8th note) will have a int for num of note
ArrayList<Integer> noteColors = new ArrayList<>(); // Since it reads as numbers...

int numNotes = 64; // Total 8th notes
int boxSize = 20; 
int spacing = 5; // Spacing between
int startX = 100;
int startY = 170;

int selectedNoteLength = 2; // 1 = 8th, 2 = quarter, etc...
Boolean selectedRest = false; // For GUI

// All the images needed: backdrops and notes
PImage intropage; 
PImage backdrop;
PImage backdrop1;
PImage eighthnote; 
PImage eighthrest;
PImage quarternote;
PImage quarterrest; 
PImage halfnote;
PImage halfrest;
PImage wholenote;
PImage wholerest;

// All 12 sounds
SoundFile plate; 
SoundFile metalbowl;
SoundFile metalteatin;
SoundFile metaldrop;
SoundFile potlid;
SoundFile clank;
SoundFile clickpen;
SoundFile pencil;
SoundFile computerping;
SoundFile clock;
SoundFile keyboard;
SoundFile printer; 

float gradientcount = 0; // For the gradient on the squares to tell which ones have notes: lerp
int gameState = 0; // 0 = Front page, 1 = Main Composing, 2 = Introduction page

boolean isPlaying = false; // Variable to tell if the composition is playing
int currentBeat = 0; 
int lastPlayTime = 0;
int beatInterval = 300; // Milliseconds per 8th note
HashMap<String, SoundFile> soundMap = new HashMap<>(); // Key Value Pairs - String = type of sound, SoundFile = sound

void setup(){
  size(1000, 600);
  createGUI();

  for (int i = 0; i < numNotes; i++) {
    noteStates.add(false); // all notes off by default
    noteColors.add(color(200)); // default color for each square
  }
  
  // Loading images
  eighthnote = loadImage("eighthnote.png");
  eighthrest = loadImage("eighthrest.png");
  quarternote = loadImage("quarternote.png"); 
  quarterrest = loadImage("quarterrest.png");
  halfnote = loadImage("halfnote.png");
  halfrest = loadImage("halfrest.png");
  wholenote = loadImage("wholenote.png");
  wholerest = loadImage("wholerest.png");
  intropage = loadImage("HomeBeats.png");
  backdrop = loadImage("backdrop.png");
  backdrop1 = loadImage("backdrop1.png");
  
  // Add the sound name, and soundfile to hashmap
  soundMap.put("Plate", new SoundFile(this, "plate.mp3"));
  soundMap.put("Metal Bowl", new SoundFile(this, "metalbowl.mp3"));
  soundMap.put("Metal Tea Tin", new SoundFile(this, "metalteatin.mp3")); 
  soundMap.put("Metal Drop", new SoundFile(this, "metaldrop.mp3")); 
  soundMap.put("Pot Lid", new SoundFile(this, "potlid.mp3")); 
  soundMap.put("Clank", new SoundFile(this, "clank.mp3")); 
  
  soundMap.put("Pen Click", new SoundFile(this, "clickpen.mp3")); 
  soundMap.put("Pencil", new SoundFile(this, "pencil.mp3"));
  soundMap.put("Computer Ping", new SoundFile(this, "computerping.mp3")); 
  soundMap.put("Clock", new SoundFile(this, "clock.mp3")); 
  soundMap.put("Keyboard", new SoundFile(this, "keyboard.mp3")); 
  soundMap.put("Printer", new SoundFile(this, "printer.mp3")); 
}

void playBeat(int beat) { // Playing the beat
  for (note n : whichNote) { // Find the note
    if (n.startbeat == beat && !n.rest) { // If it's the correct note, and it's not a rest
      SoundFile sf = soundMap.get(n.sound); // Get the sound

      // Duration using rate
      float playbackRate = 1.0; // Normal rate
      if (n.duration == 1) { // Eighth note
        playbackRate = 2.0;
      } else if (n.duration == 2) { // Quarter note
        playbackRate = 1.0;
      } else if (n.duration == 4) { // Half note
        playbackRate = 0.5;
      } else if (n.duration == 8) { // Whole note
        playbackRate = 0.25;
      }

      sf.rate(playbackRate); // Change the rate
      sf.play(); // Play the sound at the given rate
    }
  }
}

void saveNotesToFile() {
  String[] lines = new String[whichNote.size()]; // Make list of strings which be saved into textfile

  for (int i = 0; i < whichNote.size(); i++) { 
    note n = whichNote.get(i); // Get the note and it's information
    int colorValue = noteColors.get(n.startbeat); // Colour value
    // Add all the information to a line, use + to avoid spaces
    lines[i] = n.type + "," + n.rest + "," + n.sound + "," + n.startbeat + "," + n.duration + "," + colorValue;
  }
  // Save the lines into the music textfile
  saveStrings("music.txt", lines);
}

void loadNotesFromFile() { // To load the previously saved song
  whichNote.clear(); // Clear any previous notes on the screen
  noteColors = new ArrayList<Integer>(); // Clear current color list
  for (int i = 0; i < numNotes; i++) { 
    noteColors.add(color(200)); // Refill the default squares colours
  }

  String[] myMusicData = loadStrings("music.txt"); // Load textfile

  for (String line : myMusicData) { // For each line in the file
    boolean rest;
    String[] parts = split(line, ','); // Split the line into a list, split by ',' since no spaces
    if (parts.length == 6) { // 6 values
      String type = parts[0]; // Eighth, quarter, half, whole
      if (boolean(parts[1]) == true){
        rest = true;
      } else {
        rest = false;
      }
      String sound = parts[2]; // Sound name
      int startbeat = int(parts[3]);
      int duration = int(parts[4]);
      int colorValue = int(parts[5]);

      whichNote.add(new note(type, rest, sound, startbeat, duration)); // Add the note into the array
      for (int j = 0; j < duration && (startbeat + j) < numNotes; j++) { // For all the values the note covers, add colour
        noteColors.set(startbeat + j, colorValue);
      }
    }
  }
}

void draw(){
  if (gameState == 0){ // Front page
    image(intropage, 0,0);
    stroke(0);
    fill(255);
    rect(500,270,200,50, 10);
    fill(0);
    textSize(18);
    text("Start Composing", 539, 300);  // Button to bring to composing page
    fill(255);
    rect(500,340,200,50, 10);
    fill(0);
    text("Instructions", 555, 370);  // Button to bring to instructions page
  }
  
  if (gameState == 2){ // Instructions page
    image(backdrop,0,0);
    fill(255);
    rect(20,20,50,50, 10); // Button
    fill(0);
    textSize(30);
    text("<", 37, 55);  

    textSize(18);
    text("Welcome to HomeBeats where you can compose your own rhythms using everyday household items", 80, 120);  
    text("To start composing, head back to the main page and click 'Start Composing'", 80, 150);  
    text("Instructions:", 80, 220);  
    text("- Select a room and sound option", 80, 250);  
    text("- Then select the length of the note or if it is a rest", 80, 280);  
    text("- Click on a square (each square = 8th note) to place a note", 80, 310);  
    text("- Notes can be an eighth, quarter, half or whole note", 80, 340);  
    text("- Use the save and load buttons to upload your last composition", 80, 370);  
  }
  
  if (gameState == 1){ // Composing page
    image(backdrop1,0,0);

    // For the display of notes
    fill(255);
    line(90, 220, 895, 220);
    line (90, 220, 90, 290);
    line(90, 290, 895, 290);
    
    line(90, 395, 895, 395);
    line (895, 395, 895, 465);
    line(90, 465, 895, 465);

    // For the squares to click to place note
    for (int i = 0; i < numNotes; i++) {
      int row; // Find if it is the first or second row
      if (i < 32){
        row = 0;
      } else {
        row = 1;
      }
      int index = i % 32; // Since there are two rows of 32
    
      int x = startX + index * (boxSize + spacing); // X value
      int y = startY + row * (boxSize + 150); // Add spacing between rows
    
      if (isPlaying && i == currentBeat) { // If the composition is playing 
        stroke(255, 0, 0); // Give it a red outline around current beat
        strokeWeight(3);
      } else {
        stroke(0); // No outline
        strokeWeight(1);
      }
    
      fill(noteColors.get(i)); // Fill the square with given colour or default gray
      rect(x, y, boxSize, boxSize); // Draw the square
    }
    
    for (note n : whichNote) { // For each note (n) in whichNote
      int row;
      if (n.startbeat < 32){
        row = 0;
      } else {
        row = 1;
      }
      int index = n.startbeat % 32;
      int x = startX + index * (boxSize + spacing);
      int y = startY + 70 + row*170;
    
      n.drawImage(x, y, 6); // Draw the image, with a scale of 6 for most images
    }

    if (isPlaying) { // If it is currently playing
      if (millis() - lastPlayTime >= beatInterval) { 
        playBeat(currentBeat); // Play the sound
        currentBeat++; // Add to the beat count
        lastPlayTime = millis(); // Add to the count 
        
        if (currentBeat >= numNotes) { // If we are at the end (32)
          isPlaying = false; // Stop
          currentBeat = 0; // Reset
        }
      }
    }
  }
}
