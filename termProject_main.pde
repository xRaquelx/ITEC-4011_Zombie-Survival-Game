// Rachel, Sarah, Gilven
// ITEC4011 Term project
// Zombie Survival Game

// Global variables
Player player;
ScreenManager screens;

// Lists holding active game objects
ArrayList<Food> foods = new ArrayList<Food>();
ArrayList<Tree> trees;
ArrayList<Zombie> zombies = new ArrayList<Zombie>();
ArrayList<Artifact> artifacts = new ArrayList<Artifact>();

// Level tracking
int currentLevel = 1;
int artifactsNeededPerLevel = 1;
int artifactsCollectedThisLevel = 0;

boolean artifactOnMap = false;
int nextArtifactSpawnTime = 0;

int nextFoodSpawnTime = 0;
int maxFoodOnMap;

// Level 3
float heartX, heartY;
PImage heart;
float heartRadius = 30;
boolean level3HeartActive = false;

AStarPathfinder pathfinder;
ArrayList<PVector> zombieHeartPath = new ArrayList<PVector>();
int zombiePathIndex = 0;

void setup() {
  fullScreen();
  background(255);

  float playerSpawnX = 200, playerSpawnY = 200;
  float safeRadius = 150;
  trees = new ArrayList<Tree>();
  
  heart = loadImage("heart.png");

  // Perlin noise
  float noiseScale = 0.007;
  float threshold = 0.7;

  // Place a tree wherever the value exceeds the threshold
  for (int x = 0; x < width; x += 60) {
    for (int y = 0; y < height; y += 60) {
      float n = noise(x * noiseScale, y * noiseScale);
      if (n > threshold) {
        PVector pos = new PVector(x + random(-20, 20), y + random(-20, 20));

        // Player spawn safe zone
        if (dist(pos.x, pos.y, playerSpawnX, playerSpawnY) > safeRadius)
          trees.add(new Tree(pos, random(70, 110)));
      }
    }
  }

  player = new Player(200, 200);
  screens = new ScreenManager();

  nextFoodSpawnTime = millis() + (int)random(1000, 3000);
  setupLevel(currentLevel);
}

void draw() {
  background(54, 92, 48);

  if (screens.state == 2) {
    for (Tree tree : trees)
      tree.display();

    player.update();
    player.display();

    // Food
    for (int i = foods.size() - 1; i >= 0; i--) {
      Food f = foods.get(i);
      f.display();

      if (!f.collected && isColliding(player.x, player.y, player.colliderRadius, f.x, f.y, f.radius)) {
        f.collected = true;
        player.heal();
        foods.remove(i);
      }
    }

    if (currentLevel == 3)
      updateLevel3Race();
    else {
      updateArtifactSpawner();
      updateArtifacts();
      updateZombies();
      updateFoodSpawner();
    }

    drawHUD();
  }

  if (player.health == 0)
    screens.state = 4;

  screens.display(player);
}

void keyPressed() {
  player.handleKeyPressed(key);
}

void keyReleased() {
  player.handleKeyReleased(key);
}

void mousePressed() {
  screens.handleMousePressed();
}

// Food spawning
void spawnFood(int amount) {
  for (int i = 0; i < amount; i++) {
    float x = 0;
    float y = 0;
    boolean validSpot = false;

    while (!validSpot) {
      x = random(80, width - 80);
      y = random(80, height - 80);
      validSpot = true;

      for (Tree tree : trees) {
        if (dist(x, y, tree.position.x, tree.position.y) < tree.colliderRadius + 40) {
          validSpot = false;
          break;
        }
      }

      if (dist(x, y, player.x, player.y) < 120)
        validSpot = false;
    }

    foods.add(new Food(x, y));
  }
}

void updateFoodSpawner() {
  if (millis() >= nextFoodSpawnTime) {
    if (foods.size() < maxFoodOnMap)
      spawnFood(1);
    nextFoodSpawnTime = millis() + 5000;
  }
}

boolean isColliding(float x1, float y1, float r1, float x2, float y2, float r2) {
  return dist(x1, y1, x2, y2) < (r1 + r2);
}

// Level setup
void setupLevel(int levelNumber) {
  currentLevel = levelNumber;
  artifactsCollectedThisLevel = 0;

  artifacts.clear();
  artifactOnMap = false;
  zombies.clear();

  level3HeartActive = false;
  zombieHeartPath.clear();
  zombiePathIndex = 0;

  int baseTime = millis();

  if (currentLevel == 1) {
    maxFoodOnMap = 6;

    zombies.add(new Zombie(baseTime + 3000));
    zombies.add(new Zombie(baseTime + 8000));
    zombies.add(new Zombie(baseTime + 14000));
    zombies.add(new Zombie(baseTime + 20000));
  } 
  else if (currentLevel == 2) {
    maxFoodOnMap = 4;

    zombies.add(new Zombie(baseTime + 2000));
    zombies.add(new Zombie(baseTime + 5000));
    zombies.add(new Zombie(baseTime + 8000));
    zombies.add(new Zombie(baseTime + 11000));
    zombies.add(new Zombie(baseTime + 14000));
    zombies.add(new Zombie(baseTime + 17000));
    zombies.add(new Zombie(baseTime + 20000));
    zombies.add(new Zombie(baseTime + 23000));
  } 
  else if (currentLevel == 3) {
    maxFoodOnMap = 0;
    setupLevel3HeartRace();
  }

  foods.clear();
  nextFoodSpawnTime = millis() + 5000;
  nextArtifactSpawnTime = millis() + (int)random(2000, 5001);
}

// Artifacts
void updateArtifactSpawner() {
  if (!artifactOnMap && artifactsCollectedThisLevel < artifactsNeededPerLevel) {
    if (millis() >= nextArtifactSpawnTime)
      spawnArtifact();
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

    if (dist(x, y, player.x, player.y) < 150)
      validSpot = false;
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

// Level progression
void checkLevelProgress() {
  if (artifactsCollectedThisLevel >= artifactsNeededPerLevel) {
    if (currentLevel == 1)
      setupLevel(2); 
    else if (currentLevel == 2)
      setupLevel(3);
    else if (currentLevel == 3)
      screens.state = 3;
  }
}

// level 1-2 normal rounds
void updateZombies() {
  for (Zombie z : zombies) {
    z.update(player);
    z.display();

    if (isColliding(player.x, player.y, player.colliderRadius, z.x, z.y, z.colliderRadius)) {
      player.takeDamage();
    }
  }
}

// Level 3 heart race
void setupLevel3HeartRace() {
  pathfinder = new AStarPathfinder(40, trees);

  boolean validSetup = false;
  int tries = 0;

  while (!validSetup && tries < 100) {
    tries++;

    // place heart somewhere valid
    PVector heartPos = getRandomOpenSpot(200);
    heartX = heartPos.x;
    heartY = heartPos.y;

    PVector zombiePos = getRandomEdgeSpot();

    Zombie z = new Zombie(0);
    z.x = zombiePos.x;
    z.y = zombiePos.y;
    z.state = Zombie.WANDER;

    zombies.clear();
    zombies.add(z);

    zombieHeartPath = pathfinder.findPath(z.x, z.y, heartX, heartY);

    if (zombieHeartPath != null && zombieHeartPath.size() > 0) {
      zombiePathIndex = 0;
      level3HeartActive = true;
      validSetup = true;
    }
  }

  // fallback in case pathfinding fails too many times
  if (!validSetup) {
    heartX = width - 200;
    heartY = height - 200;

    Zombie z = new Zombie(0);
    z.x = 100;
    z.y = 100;
    z.state = Zombie.WANDER;

    zombies.clear();
    zombies.add(z);

    zombieHeartPath = new ArrayList<PVector>();
    zombieHeartPath.add(new PVector(heartX, heartY));
    zombiePathIndex = 0;
    level3HeartActive = true;
  }
}

void updateLevel3Race() {
  if (!level3HeartActive || zombies.size() == 0) return;

  drawHeart();

  Zombie z = zombies.get(0);

  if (isColliding(player.x, player.y, player.colliderRadius, heartX, heartY, heartRadius)) {
    screens.state = 3;
    return;
  }

  moveZombieAlongPath(z, zombieHeartPath, 7);
  z.display();

  if (isColliding(z.x, z.y, z.colliderRadius, heartX, heartY, heartRadius)) {
    player.health = 0;
    screens.state = 4;
    return;
  }
}

void drawHeart() {
  imageMode(CENTER);
  image(heart, heartX, heartY, 100, 100);
}

void moveZombieAlongPath(Zombie z, ArrayList<PVector> path, float moveSpeed) {
  if (path == null || path.size() == 0) return;
  if (zombiePathIndex >= path.size()) return;

  PVector target = path.get(zombiePathIndex);
  PVector current = new PVector(z.x, z.y);
  PVector dir = PVector.sub(target, current);

  float d = dir.mag();

  if (d < 5) {
    zombiePathIndex++;
    return;
  }

  dir.normalize();
  z.x += dir.x * moveSpeed;
  z.y += dir.y * moveSpeed;
}

PVector getRandomOpenSpot(float minPlayerDistance) {
  while (true) {
    float x = random(100, width - 100);
    float y = random(100, height - 100);

    boolean valid = true;

    if (dist(x, y, player.x, player.y) < minPlayerDistance)
      valid = false;

    for (Tree tree : trees) {
      if (dist(x, y, tree.position.x, tree.position.y) < tree.colliderRadius + 60) {
        valid = false;
        break;
      }
    }

    if (valid) {
      return new PVector(x, y);
    }
  }
}

PVector getRandomEdgeSpot() {
  while (true) {
    int edge = (int)random(4);
    float x = 0;
    float y = 0;

    if (edge == 0) {
      x = random(50, width - 50);
      y = 50;
    } 
    else if (edge == 1) {
      x = random(50, width - 50);
      y = height - 50;
    } 
    else if (edge == 2) {
      x = 50;
      y = random(50, height - 50);
    } 
    else {
      x = width - 50;
      y = random(50, height - 50);
    }

    boolean valid = true;

    for (Tree tree : trees) {
      if (dist(x, y, tree.position.x, tree.position.y) < tree.colliderRadius + 60) {
        valid = false;
        break;
      }
    }
    
    if (valid)
      return new PVector(x, y);
  }
}

// HUD
void drawHUD() {
  fill(255);
  textSize(28);
  textAlign(LEFT, TOP);
  text("Level: " + currentLevel, 20, 20);

  if (currentLevel == 3) {
    text("Race to the heart!", 20, 60);
  } else {
    text("Artifacts: " + artifactsCollectedThisLevel + "/" + artifactsNeededPerLevel, 20, 60);
  }
}
