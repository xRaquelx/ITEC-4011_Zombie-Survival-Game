class Zombie {
  int state = 0;
  
  PImage zombieImg;
  
  int size = 90;
  float colliderRadius = 45;
  
  float x, y;
  float speed = 1.5;
  
  float targetX, targetY;
  
  Zombie(float startX, float startY, float tx, float ty) {
    x = startX;
    y = startY;
    targetX = tx;
    targetY = ty;
    zombieImg = loadImage("tempZombie.png");
  }
  
    void update() {
    float dx = targetX - x;
    float dy = targetY - y;
    float d = dist(x, y, targetX, targetY);

    if (d > 1) {
      x += (dx / d) * speed;
      y += (dy / d) * speed;
    }
  }
  
  void display() {
    imageMode(CENTER);
    image(zombieImg, x, y, size, size * 2);
  }
}
