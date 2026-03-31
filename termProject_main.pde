Player player;
ScreenManager screens;

void setup() {
  fullScreen();
  background(255);
  
  player = new Player(200, 200);
  screens = new ScreenManager();
}

void draw() {
  background(255);
  
  screens.display(player);
}

//----- Screen manager -----
void mousePressed() {
  screens.handleMousePressed();
}

//----- Player -----
void keyPressed() {
  player.handleKeyPressed(key);
}

void keyReleased() {
  player.handleKeyReleased(key);
}
