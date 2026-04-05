// Global variables
Player player;
ScreenManager screens;

ArrayList<Food> foods = new ArrayList<Food>();
ArrayList<Tree> trees;

void setup() {
  fullScreen();
  background(255);

  //// Create trees
  //trees = new ArrayList<Tree>();
  //for (int i = 0; i < 20; i++) {
  //  trees.add(new Tree(new PVector(random(width), random(height)), random(80, 120)));
  //}
  
  // Create trees and not spawn where player spawns
  float playerSpawnX = 200, playerSpawnY = 200;
  float safeRadius = 150;
  trees = new ArrayList<Tree>();
  for (int i = 0; i < 20; i++) {
    PVector pos;
    do {
      pos = new PVector(random(width), random(height));
    } while (dist(pos.x, pos.y, playerSpawnX, playerSpawnY) < safeRadius);
    trees.add(new Tree(pos, random(80, 120)));
  }

  player = new Player(200, 200);

  // Create Screen Manager
  screens = new ScreenManager();

  // Spawn food
  spawnFood(10);
}

void draw() {
  background(54, 92, 48);

  // Display trees
  for (Tree tree : trees) {
    tree.display();
  }

  // Display player and health
  player.update();
  player.display();

  // Display food and check collection
  for (int i = foods.size() - 1; i >= 0; i--) {
    Food f = foods.get(i);
    f.display();

    // Player collects food
    if (!f.collected && isColliding(player.x, player.y, player.colliderRadius, f.x, f.y, f.radius)) {
      f.collected = true;
      player.heal();
      foods.remove(i); // Remove collected food
    }
  }

  // Screen manager overlay (menus)
  screens.display(player);
}

// Input handlers
void keyPressed()   { player.handleKeyPressed(key); }
void keyReleased()  { player.handleKeyReleased(key); }
void mousePressed() { screens.handleMousePressed(); }

// Spawn food
void spawnFood(int amount){
  for (int i = 0; i < amount; i++){
    float x = random(width);
    float y = random(height);
    foods.add(new Food(x, y));
  }
}

// Collision detection
boolean isColliding(float x1, float y1, float r1, float x2, float y2, float r2) {
  return dist(x1, y1, x2, y2) < (r1 + r2);
}
