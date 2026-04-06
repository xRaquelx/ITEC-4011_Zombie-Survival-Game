// Global variables
Player player;
ScreenManager screens;

ArrayList<Food>   foods   = new ArrayList<Food>();
ArrayList<Tree>   trees;
ArrayList<Zombie> zombies = new ArrayList<Zombie>();

void setup() {
  fullScreen();
  background(255);

  // Create trees (avoid player spawn area)
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
  screens = new ScreenManager();
  spawnFood(10);

  //level 1
  // 4 zombies
  zombies.add(new Zombie(3000));   // spawns at  3s
  zombies.add(new Zombie(8000));   // spawns at  8s
  zombies.add(new Zombie(14000));  // spawns at 14s
  zombies.add(new Zombie(20000));  // spawns at 20s
}

void draw() {
  background(54, 92, 48);

  for (Tree tree : trees) {
    tree.display();
  }

  player.update();
  player.display();

  for (int i = foods.size() - 1; i >= 0; i--) {
    Food f = foods.get(i);
    f.display();
    if (!f.collected && isColliding(player.x, player.y, player.colliderRadius, f.x, f.y, f.radius)) {
      f.collected = true;
      player.heal();
      foods.remove(i);
    }
  }

  // Update and display zombies
  for (Zombie z : zombies) {
    z.update(player);
    z.display();
  }

  screens.display(player);
}

void keyPressed()   { player.handleKeyPressed(key); }
void keyReleased()  { player.handleKeyReleased(key); }
void mousePressed() { screens.handleMousePressed(); }

void spawnFood(int amount) {
  for (int i = 0; i < amount; i++) {
    foods.add(new Food(random(width), random(height)));
  }
}

  boolean isColliding(float x1, float y1, float r1, float x2, float y2, float r2) {
  return dist(x1, y1, x2, y2) < (r1 + r2);
}
