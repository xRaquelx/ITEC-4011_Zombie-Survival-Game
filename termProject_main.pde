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

int nextFoodSpawnTime = 0;
int maxFoodOnMap;

void setup() {
  fullScreen();
  background(255);

  float playerSpawnX = 200, playerSpawnY = 200;
  float safeRadius = 150;
  trees = new ArrayList<Tree>();

  //make smaller for larger forest clusters
  float noiseScale = 0.007;
  //make higher for sparser map
  float threshold = 0.7;
  
  for (int x = 0; x < width; x += 60) {
    for (int y = 0; y < height; y += 60) {
      float n = noise(x * noiseScale, y * noiseScale);
      if (n > threshold) {
        PVector pos = new PVector(x + random(-20, 20), y + random(-20, 20));
        if (dist(pos.x, pos.y, playerSpawnX, playerSpawnY) > safeRadius) {
          trees.add(new Tree(pos, random(70, 110)));
        }
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

    updateArtifactSpawner();
    updateArtifacts();
    updateZombies();
    drawHUD();
    updateFoodSpawner();
  }

  screens.display(player);
}

void keyPressed()   { player.handleKeyPressed(key); }
void keyReleased()  { player.handleKeyReleased(key); }
void mousePressed() { screens.handleMousePressed(); }

void spawnFood(int amount) {
  for (int i = 0; i < amount; i++) {
    float x = 0;
    float y = 0;
    boolean validSpot = false;
    
    while (!validSpot) {
      x = random(80, width - 80);
      y = random(80, height - 80);
      validSpot = true;
      for (Tree tree: trees) {
        if (dist(x, y, tree.position.x, tree.position.y) < tree.colliderRadius + 40) {
          validSpot = false;
          break;
        }
      }
      if (dist(x, y, player.x, player.y) < 120) {
        validSpot = false;
      }
    }
    foods.add(new Food(x, y));
  }
}

void updateFoodSpawner() {
  if (millis() >= nextFoodSpawnTime) {
    if (foods.size() < maxFoodOnMap) {
      spawnFood(1); 
    }
    nextFoodSpawnTime = millis() + 5000;
  }
}

boolean isColliding(float x1, float y1, float r1, float x2, float y2, float r2) {
  return dist(x1, y1, x2, y2) < (r1 + r2);
}

void setupLevel(int levelNumber) {
  currentLevel = levelNumber;
  artifactsCollectedThisLevel = 0;

  artifacts.clear();
  artifactOnMap = false;
  
  zombies.clear();

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
    maxFoodOnMap = 3;
    zombies.add(new Zombie(baseTime + 2000));
    zombies.add(new Zombie(baseTime + 5000));
    zombies.add(new Zombie(baseTime + 8000));
    zombies.add(new Zombie(baseTime + 11000));
  }

  foods.clear();
  nextFoodSpawnTime = millis() + 5000;
  nextArtifactSpawnTime = millis() + (int)random(2000, 5001);
}

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
    else if (currentLevel == 2)
      setupLevel(3);
    else if (currentLevel == 3)
      screens.state = 3;
  }
}

void updateZombies() {
  for (Zombie z : zombies) {
    z.update(player);
    z.display();

    if (isColliding(player.x, player.y, player.colliderRadius, z.x, z.y, z.colliderRadius)) {
      player.takeDamage();
    }
  }
}

void drawHUD() {
  if (screens.state == 0 || screens.state == 1 || screens.state == 3)
    return;
  fill(255);
  textAlign(LEFT, TOP);
  textSize(28);
  text("Level: " + currentLevel, 30, 30);
  text("Artifacts: " + artifactsCollectedThisLevel + " / " + artifactsNeededPerLevel, 30, 70);
}
