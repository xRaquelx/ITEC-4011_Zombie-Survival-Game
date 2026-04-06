// Global variables
Player player;
ScreenManager screens;

ArrayList<Food> foods = new ArrayList<Food>();
ArrayList<Tree> trees;
ArrayList<Zombie> zombies = new ArrayList<Zombie>();
ArrayList<Artifact> artifacts = new ArrayList<Artifact>();

int currentLevel = 1;
int artifactsNeededPerLevel = 3;
int artifactsCollectedThisLevel = 0;

boolean artifactOnMap = false;
int nextArtifactSpawnTime = 0;

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
  
  setupLevel(currentLevel);
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
  
  screens.display(player);
  
  updateArtifactSpawner();
  updateArtifacts();
  
  updateZombies();
  
  drawHUD();
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

// ----- Level Setup -----
void setupLevel(int levelNumber) {
  currentLevel = levelNumber;
  artifactsCollectedThisLevel = 0;

  artifacts.clear();
  artifactOnMap = false;

  int baseTime = millis();

  if (currentLevel == 1) {
    // max 4 zombies
    zombies.add(new Zombie(baseTime + 3000));
    zombies.add(new Zombie(baseTime + 8000));
    zombies.add(new Zombie(baseTime + 14000));
    zombies.add(new Zombie(baseTime + 20000));
  } 
  if (currentLevel == 2) {
    // max 8 zombies
    zombies.add(new Zombie(baseTime + 2000));
    zombies.add(new Zombie(baseTime + 5000));
    zombies.add(new Zombie(baseTime + 8000));
    zombies.add(new Zombie(baseTime + 11000));
    zombies.add(new Zombie(baseTime + 14000));
    zombies.add(new Zombie(baseTime + 17000));
    zombies.add(new Zombie(baseTime + 20000));
    zombies.add(new Zombie(baseTime + 23000));
  }

  nextArtifactSpawnTime = millis() + (int)random(2000, 5001);
}



// ----- Artifact Spawning -----
void updateArtifactSpawner() {
  if (!artifactOnMap && artifactsCollectedThisLevel < artifactsNeededPerLevel) {
    if (millis() >= nextArtifactSpawnTime) {
      spawnArtifact();
    }
  }
}

void spawnArtifact() {
  float x = 0;
  float y = 0;
  boolean validSpot = false;

  while (!validSpot) {
    x = random(80, width - 80);
    y = random(80, height - 80);
    validSpot = true;

    for (Tree tree : trees) {
      if (dist(x, y, tree.position.x, tree.position.y) < tree.colliderRadius + 50) {
        validSpot = false;
        break;
      }
    }

    if (dist(x, y, player.x, player.y) < 150) {
      validSpot = false;
    }
  }

  artifacts.add(new Artifact(x, y));
  artifactOnMap = true;
}

void updateArtifacts() {
  for (int i = artifacts.size() - 1; i >= 0; i--) {
    Artifact a = artifacts.get(i);
    a.display();

    if (!a.collected && isColliding(player.x, player.y, player.colliderRadius, a.x, a.y, a.radius)) {
      a.collected = true;
      artifacts.remove(i);

      artifactOnMap = false;
      artifactsCollectedThisLevel++;

      nextArtifactSpawnTime = millis() + (int)random(2000, 5001);

      checkLevelProgress();
    }
  }
}

void checkLevelProgress() {
  if (artifactsCollectedThisLevel >= artifactsNeededPerLevel) {
    if (currentLevel == 1)
      setupLevel(2);
    else if (currentLevel == 2) {
      screens.state = 3;
      zombies.clear();
    }      
  }
}

// ----- Zombies -----
void updateZombies() {
  for (Zombie z : zombies) {
    z.update(player);
    z.display();
  }
}

// ----- HUD -----
void drawHUD() {
  if (screens.state == 0 || screens.state == 1 || screens.state == 3)
    return;
  fill(255);
  textAlign(LEFT, TOP);
  textSize(28);
  text("Level: " + currentLevel, 30, 30);
  text("Artifacts: " + artifactsCollectedThisLevel + " / " + artifactsNeededPerLevel, 30, 70);
}
