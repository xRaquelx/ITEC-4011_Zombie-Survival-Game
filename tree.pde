class Tree {

  PImage treeImg;
  PVector position;
  float radius;

  //collider radius
  float colliderRadius;

  Tree(PVector mPosition, float mRadius) {
    treeImg = loadImage("spruceTree.png");
    position = mPosition;
    radius = mRadius;
    colliderRadius = radius * 0.5;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    imageMode(CENTER);
    image(treeImg, 0, 0, radius * 2, radius * 2);
    popMatrix();

    //collider stroke
     //noFill();
     //stroke(0, 0, 255);
     //ellipse(position.x, position.y, colliderRadius * 2, colliderRadius * 2);
  }
}
