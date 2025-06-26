void mousePressed() {
  if (gameState == 0){ // If it is on the front page, check if they clicked any buttons
    if (mouseX >= 500 && mouseX <= 700 && mouseY >= 270 && mouseY <= 320) { // Composing button
      gameState = 1;  
    }
    if (mouseX >= 500 && mouseX <= 700 && mouseY >= 340 && mouseY <= 390) { // Instruction button
      gameState = 2;  
    }  
  }
  
  if (gameState == 2){ // If on the instruction page, go back to the front page
    if (mouseX >= 20 && mouseX <= 70 && mouseY >= 20 && mouseY <= 70) {
      gameState = 0;  
    }  
  }

  if (gameState == 1) { // If it is on the composing page
    for (int i = 0; i < numNotes; i++) {
      int row;
      if (i < 32){
        row = 0;
      } else {
        row = 1;
      }
      int index = i % 32; // Find index within row
      
      int x = startX + index * (boxSize + spacing);
      int y = startY + row * (boxSize + 150);
      
      if (mouseX >= x && mouseX <= x + boxSize && mouseY >= y && mouseY <= y + boxSize) { // If it's clicked inside the squares
        // Don't let them place a note if it goes off the grid (64 notes)
        if (i + selectedNoteLength > numNotes) { 
          return;
        }
      
        // Overlap check
        boolean isOverlapping = false;
        for (note n : whichNote) { // Loop through each note
          int noteStart = n.startbeat; // Start of existing note
          int noteEnd = n.startbeat + n.duration - 1; // End of beat
          for (int b = i; b < i + selectedNoteLength && b < numNotes; b++) {
            if (b >= noteStart && b <= noteEnd) {
              isOverlapping = true; // Found overlap
              break;
            }
          }
          if (isOverlapping) {
            break; // Exit if overlap
          }
        }
      
        if (isOverlapping) {
          return; // Don't place note if it's overlapping
        }
      
        // Color squares
        for (int j = 0; j < selectedNoteLength && (i + j) < numNotes; j++) {
          noteStates.set(i + j, !noteStates.get(i + j));
          if (gradientcount < 1){
            noteColors.set(i + j, lerpColor(color(255, 0, 0), color(0, 0, 255), gradientcount)); // First 32 notes...
          } else {
            noteColors.set(i + j, lerpColor(color(0, 0, 255), color(255, 255, 0), gradientcount-1)); // Other 32 notes...
  
          }
        }
      
        // Create note
        String type = "";
        if (selectedNoteLength == 1){
          type = "Eighth";
        } else if (selectedNoteLength == 2){
          type = "Quarter";
        } else if (selectedNoteLength == 4){
          type = "Half";
        } else if (selectedNoteLength == 8){
          type = "Whole";
        }
      
        String sound = soundList.getSelectedText(); // Get the sound
        whichNote.add(new note(type, selectedRest, sound, i, selectedNoteLength)); // Add a new note 
        gradientcount += 0.03; // Add to the gradient count for lerp
      }
    }
  }
}
