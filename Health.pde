// Player Health System 
class Player {
    float x, y;
    int health = 100;
    int maxHealth = 100;

    Player(float x, float y) {
        this.x = x;
        this.y = y;
    }

    void damage(int amount) {
        health -= amount;
        health = constrain(health, 0, maxHealth);
    }

    void heal(int amount) {
        health += amount; 
        health = constrain(health, 0, maxHealth);
    }

    void display() {
        fill(0, 0, 255);
        ellipse(x, y, 30, 30);
    }
}


// Zombie 
class Zombie {
    float x, y;
    int health = 50; 
    int maxHealth = 50;

    Zombie(float x, float y) {
        this.x = x;
        this.y = y;
    }

    void display() {
        fill(0, 200, 0);
        ellipse(x, y, 30, 30);
    }

    void damage(int amount) {
        health -= amount;
        health = constrain(health, 0, maxHealth);
    }

    boolean isDead() {
        return health <= 0;
    }
}


// Food
class Food {
  float x, y;
  boolean collected = false;

  Food(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    if (!collected) {
      fill(255, 100, 0);
      ellipse(x, y, 20, 20);
    }
  }
}