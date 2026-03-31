class Tree {
  
  PImage treeImg;
  PVector position;
  float radius;
  
  Tree(PVector mPosition, float mRadius) {
    treeImg = loadImage("spruceTree.png");
    position = mPosition;
    radius = mRadius;
  }
  
  void display() {
    pushMatrix();
    translate(position.x, position.y);
    imageMode(CENTER);
    image(treeImg, 0, 0, radius * 2, radius * 2);
    popMatrix();
  }
  
}
