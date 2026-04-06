class Zombie {
  int state = 0;
  
  PImage zombieImg;
  
  int size = 90;
  float colliderRadius = 45;
  
  float x, y;
  float speed = 1.5;
  
  Zombie(float startX, float startY) {
    x = startX;
    y = startY;
  }
  
  void display() {
    imageMode(CENTER);
    image(zombieImg, x, y, size, size * 2);
  }
}
