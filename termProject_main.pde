ArrayList<Tree> trees;

Player player;
ScreenManager screens;

void setup() {
  fullScreen();
  background(255);
  
  trees = new ArrayList<Tree>();
  for (int i = 0; i < 25; i++) {
    trees.add(new Tree(new PVector(random(width), random(height)), random(60, 100)));
  }
  player = new Player(200, 200);
  screens = new ScreenManager();
}

void draw() {
  background(255);
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
