ArrayList<Tree> trees;

Player player;
ScreenManager screens;

ArrayList<Food> foods = new ArrayList<Food>();

void setup() {
  fullScreen();
  background(255);
  
  trees = new ArrayList<Tree>();
  for (int i = 0; i < 20; i++) {
    trees.add(new Tree(new PVector(random(width), random(height)), random(80, 120)));
  }
  player = new Player(200, 200);
  screens = new ScreenManager();

  spawnfood(10); //spawns food here
}

void draw() {
  background(54, 92, 48);
  for (Tree tree : trees) {
    tree.display();
  }
  screens.display(player);
}

//----- Screen manager -----
void mousePressed() {
  screens.handleMousePressed();
}

//----- Player -----
void keyPressed() {
  player.handleKeyPressed(key);
}

void keyReleased() {
  player.handleKeyReleased(key);
}

//----- Spawning Food -----

void spawnFood(int amount){
  for (int i = 0; i < amount; i++){
    float x = random(width)
    float y = random(height)
    float add = (new Food(x, y));
  }
}

//----- Collision Detection -----

boolean isColliding(float x1, float y1, float r1,
                    float x2, float y2, float r2) {
  return dist(x1, y1, x2, y2) < (r1 + r2);
}





