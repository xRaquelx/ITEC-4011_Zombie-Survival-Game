class Player {
  float x, y;
  float size = 100;
  PImage playerImg;
  float speed = 3;
  boolean w, a, s, d;
  
  Player(float startX, float startY) {
    x = startX;
    y = startY;
    playerImg = loadImage("data/images/player.png");
  }
  
  void display() {
    image(playerImg, x, y, size, size * 2);
  }
  
  void update() {
    if (w) 
      y -= speed;
    if (s) 
      y += speed;
    if (a) 
      x -= speed;
    if (d) 
      x += speed;
  }
  
  void handleKeyPressed(char key) {
    if (key == 'w' || key == 'W') 
      w = true;
    if (key == 'a' || key == 'A') 
      a = true;
    if (key == 's' || key == 'S') 
      s = true;
    if (key == 'd' || key == 'D') 
      d = true;
  }

  void handleKeyReleased(char key) {
    if (key == 'w' || key == 'W') 
      w = false;
    if (key == 'a' || key == 'A') 
      a = false;
    if (key == 's' || key == 'S') 
      s = false;
    if (key == 'd' || key == 'D') 
      d = false;
  }
}
