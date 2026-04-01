class Player {
  float x, y;
  float size = 90;
  PImage playerImg;
  float speed = 3;
  boolean w, a, s, d;

  float colliderRadius = 45;

  Player(float startX, float startY) {
    x = startX;
    y = startY;
    playerImg = loadImage("player.png");
  }

  float colliderX() {
    return x;
  }

  float colliderY() {
    return y;
  }

  void display() {
    imageMode(CENTER);
    image(playerImg, x, y, size, size * 2);

    //noFill();
    //stroke(255, 0, 0);
    //ellipse(colliderX(), colliderY(), colliderRadius * 2, colliderRadius * 2);
  }

  void update() {
    if (w) {
      y -= speed;
      if (collidesWithAnyTree()) y += speed;
    }
    if (s) {
      y += speed;
      if (collidesWithAnyTree()) y -= speed;
    }
    if (a) {
      x -= speed;
      if (collidesWithAnyTree()) x += speed;
    }
    if (d) {
      x += speed;
      if (collidesWithAnyTree()) x -= speed;
    }
  }

  boolean collidesWithAnyTree() {
    for (Tree tree : trees) {
      float dx = colliderX() - tree.position.x;
      float dy = colliderY() - tree.position.y;
      float distance = sqrt(dx * dx + dy * dy);
      if (distance < colliderRadius + tree.colliderRadius) {
        return true;
      }
    }
    return false;
  }

  void handleKeyPressed(char key) {
    if (key == 'w' || key == 'W') w = true;
    if (key == 'a' || key == 'A') a = true;
    if (key == 's' || key == 'S') s = true;
    if (key == 'd' || key == 'D') d = true;
  }

  void handleKeyReleased(char key) {
    if (key == 'w' || key == 'W') w = false;
    if (key == 'a' || key == 'A') a = false;
    if (key == 's' || key == 'S') s = false;
    if (key == 'd' || key == 'D') d = false;
  }
}
