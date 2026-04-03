class ScreenManager {
  int state = 0;
  
  PImage startMenuImg;
  PImage instructionMenuImg; 
  PImage button;
  
  float menuButtonX, menuButtonY, menuButtonW, menuButtonH;
  float instrButtonX, instrButtonY, instrButtonW, instrButtonH;
  
  ScreenManager() {
    startMenuImg = loadImage("startMenu.png");
    instructionMenuImg = loadImage("instructionsMenu.png");
    button = loadImage("button.png");

    menuButtonW = 200;
    menuButtonH = 100;
    menuButtonX = width / 2 - menuButtonW / 2;
    menuButtonY = height / 2;

    instrButtonW = 200;
    instrButtonH = 100;
    instrButtonX = width / 2 - instrButtonW / 2;
    instrButtonY = height - 350;
  }
  
  void display(Player player) {
    if (state == 0)
      drawMenu();
    else if (state == 1)
      drawInstructions();
    else if (state == 2) {

      // Player 
      player.update();
      player.display();
      player.drawHealthBar(); // Adds player health bar 

      // Food 
      for (Food f: foods) {
        f.display();

      // Player collects food 
        if (!f.collected && isColliding(player.x, player.y, player.colliderRadius, f.x, f.y, f.radius)) {
      f.collected = true;
      player.heal();
    }
  }

      // Food collected is removed
      for (int i = foods.size() - 1; i >=0; i--) {
        if (foods.get(i).collected) { 
          foods.remove(i);
        }
      }
    }
  }
  
  void drawMenu() {
    imageMode(CENTER);
    image(startMenuImg, width/2, height/2, width, height);
    image(button, width / 2, menuButtonY +  menuButtonH / 2, menuButtonW, menuButtonH);
  }
  
  void drawInstructions() {
    imageMode(CENTER);
    image(instructionMenuImg, width/2, height/2, width, height);
    image(button, width / 2, instrButtonY +  instrButtonH / 2, instrButtonW, instrButtonH);
  }
  
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
