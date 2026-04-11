class ScreenManager {
  int state = 0;
  
  // Screen images 
  PImage startMenuImg;
  PImage instructionMenuImg; 
  PImage endWinImg;
  PImage endLoseImg;
  PImage button;
  
  // Button positions 
  float menuButtonX, menuButtonY, menuButtonW, menuButtonH;
  float instrButtonX, instrButtonY, instrButtonW, instrButtonH;
  
  ScreenManager() {
    startMenuImg = loadImage("startMenu.png");
    instructionMenuImg = loadImage("instructionsMenu.png");
    button = loadImage("button.png");
    endWinImg = loadImage("endWin.png");
    endLoseImg = loadImage("endLose.png");

    menuButtonW = 200;
    menuButtonH = 100;
    menuButtonX = width / 2 - menuButtonW / 2;
    menuButtonY = height / 2 + 200; 

    instrButtonW = 200;
    instrButtonH = 100;
    instrButtonX = width / 2 - instrButtonW / 2;
    instrButtonY = height - 250;
  }
  
  void display(Player player) {
    if (state == 0)
      drawMenu();
    else if (state == 1)
      drawInstructions();
    else if (state == 2) {
      player.drawHealthBar(); // Adds player health bar 
    }
    else if (state == 3)
      drawEndWin();
    else if (state == 4)
      drawEndLose();
  }
  
  // Draws menu screen
  void drawMenu() {
    imageMode(CENTER);
    image(startMenuImg, width/2, height/2, width, height);
    image(button, width / 2, menuButtonY +  menuButtonH / 2, menuButtonW, menuButtonH);
  }
  
  // Draws instruction screen 
  void drawInstructions() {
    imageMode(CENTER);
    image(instructionMenuImg, width/2, height/2, width, height);
    image(button, width / 2, instrButtonY +  instrButtonH / 2, instrButtonW, instrButtonH);
  }
  
  // Draws win end screen
  void drawEndWin() {
    imageMode(CENTER);
    image(endWinImg, width/2, height/2, width, height);
  }
  
  // Draw lose end screen 
  void drawEndLose() {
    imageMode(CENTER);
    image(endLoseImg, width/2, height/2, width, height);
  }
  
  // Handles button press for "Play" 
  void handleMousePressed() {
    if (state == 0) {
      if (mouseX > menuButtonX && mouseX < menuButtonX + menuButtonW && mouseY > menuButtonY && mouseY < menuButtonY + menuButtonH)
        state = 1;
    }
    else if (state == 1) {
      if (mouseX > instrButtonX && mouseX < instrButtonX + instrButtonW && mouseY > instrButtonY && mouseY < instrButtonY + instrButtonH)
        state = 2;
    }
  }
}
