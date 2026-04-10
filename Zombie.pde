class Zombie {
  // States
  static final int INACTIVE = 0;
  static final int WANDER   = 1;
  static final int CHASE    = 2;
  static final int ATTACK   = 3;

  int state = INACTIVE;

  PImage zombieImg;
  int size = 70;

  float x, y;
  float speed       = 1.5;
  float chaseSpeed  = 3.5;
  float colliderRadius = 45;

  int spawnTime;

  // Steering
  PVector wanderDir;
  int wanderChangeInterval = 120;
  int wanderTimer = 0;

  // PLayer distance to trigger steering
  float chaseRadius = 250;
  
  // Player distance to trigger zombie chase
  float attackRadius = 80;

  Zombie(int spawnAtMillis) {
    spawnTime  = spawnAtMillis;
    zombieImg  = loadImage("zombie.png");
    wanderDir  = randomDir();
  }

  void update(Player player) {
    if (state == INACTIVE) {
      if (millis() >= spawnTime) activate();
      return;
    }

    float dToPlayer = dist(x, y, player.x, player.y);

    if (dToPlayer < chaseRadius) {
      state = CHASE;
    } else {
      state = WANDER;
    }

    if (state == WANDER) {
      doWander();
    } else {
      doChase(player); // Pursue
    }
    
    // Attack state
    if (state == CHASE && dToPlayer <= attackRadius) {
      doAttack(player);
    }

    // Collision avoidance
    x = constrain(x, colliderRadius, width  - colliderRadius);
    y = constrain(y, colliderRadius, height - colliderRadius);
  }

  void display() {
    if (state == INACTIVE) return;
    imageMode(CENTER);
    image(zombieImg, x, y, size, size * 2);
  }

  // Spawn at random edge of the screen
  void activate() {
    int edge = (int)random(4);
    switch (edge) {
      case 0: x = random(width);  y = 0;              break; // top
      case 1: x = random(width);  y = height;          break; // bottom
      case 2: x = 0;              y = random(height);  break; // left
      default:x = width;          y = random(height);  break; // right
    }
    state = WANDER;
    wanderDir = randomDir();
  }

// Wander state
 void doWander() {
    wanderTimer++;
    if (wanderTimer >= wanderChangeInterval) {
      wanderDir = randomDir();
      wanderTimer = 0;
    }

    // Move X, revert and pick new direction if hit a tree
    x += wanderDir.x * speed;
    if (collidesWithAnyTree()) {
      x -= wanderDir.x * speed;
      wanderDir.x *= -1;  // Bounce off the tree horizontally
    }

    // Move Y, revert and pick new direction if hit a tree
    y += wanderDir.y * speed;
    if (collidesWithAnyTree()) {
      y -= wanderDir.y * speed;
      wanderDir.y *= -1;  // Bounce off the tree vertically
    }

    if (x <= colliderRadius || x >= width  - colliderRadius) wanderDir.x *= -1;
    if (y <= colliderRadius || y >= height - colliderRadius) wanderDir.y *= -1;
  }

// Pursue state
  void doChase(Player player) {
    PVector toPlayer = new PVector(player.x - x, player.y - y);
    toPlayer.normalize();

    x += toPlayer.x * chaseSpeed;
    if (collidesWithAnyTree()) {
      x -= toPlayer.x * chaseSpeed;
    }

    y += toPlayer.y * chaseSpeed;
    if (collidesWithAnyTree()) {
      y -= toPlayer.y * chaseSpeed;
    }
  }

  // Returns true if this zombie's collider overlaps any tree's collider
  boolean collidesWithAnyTree() {
    for (Tree tree : trees) {
      float dx = x - tree.position.x;
      float dy = y - tree.position.y;
      if (sqrt(dx*dx + dy*dy) < colliderRadius + tree.colliderRadius) return true;
    }
    return false;
  }

  // Returns a random unit vector
  PVector randomDir() {
    float angle = random(TWO_PI);
    return new PVector(cos(angle), sin(angle));
  }
  
  // Attack state
  void doAttack (Player player) {
    player.takeDamage();
  }
}
