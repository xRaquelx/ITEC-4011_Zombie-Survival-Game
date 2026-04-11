class Player {
  float x, y;
  float size = 65;
  PImage playerImg;
  float speed = 4;
  
  // wasd key states
  boolean w, a, s, d;

  float colliderRadius = 45;

  int health = 100;
  int maxHealth = 100;

  // Damage cooldown 
  int damageCooldown = 500;
  int lastDamageTime = -500;

  Player(float startX, float startY) {
    x = startX;
    y = startY;
    playerImg = loadImage("player.png");
  }

// Movement and collision
  void update() {
    if (w) { y -= speed; if (collidesWithAnyTree()) y += speed; }
    if (s) { y += speed; if (collidesWithAnyTree()) y -= speed; }
    if (a) { x -= speed; if (collidesWithAnyTree()) x += speed; }
    if (d) { x += speed; if (collidesWithAnyTree()) x -= speed; }
    
// Canvas boundary
    float margin = 30;
    x = constrain(x, -margin, width  + margin);
    y = constrain(y, -margin, height + margin);
  }

  void display() {
    imageMode(CENTER);
    image(playerImg, x, y, size, size * 2);
  }

  void drawHealthBar() {
    fill(100);
    rect(x - 50, y - 100, 100, 10);
    fill(0, 255, 0);
    float healthPercent = (float)health / maxHealth;
    rect(x - 50, y - 100, 100 * healthPercent, 10);
  }

// Restore 10 hp when food collected
  void heal() {
    health += 10;
    if (health > maxHealth) health = maxHealth;
  }

  void takeDamage() {
    if (millis() - lastDamageTime >= damageCooldown) {
      health -= 5;
      if (health < 0) health = 0;
      lastDamageTime = millis();
    }
  }

// Tree collision
  boolean collidesWithAnyTree() {
    for (Tree tree : trees) {
      float dx = x - tree.position.x;
      float dy = y - tree.position.y;
      float distance = sqrt(dx*dx + dy*dy);
      if (distance < colliderRadius + tree.colliderRadius) return true;
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
