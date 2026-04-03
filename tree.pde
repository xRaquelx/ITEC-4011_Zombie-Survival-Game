class Tree {
  PImage treeImg;
  PVector position;
  float radius;
  float colliderRadius;

  Tree(PVector pos, float rad) {
    position = pos;
    radius = rad;
    colliderRadius = radius * 0.5;
    treeImg = loadImage("spruceTree.png");
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    imageMode(CENTER);
    image(treeImg, 0, 0, radius*2, radius*2);
    popMatrix();
  }
}
