class Artifact {
  float x, y;
  float radius = 30;
  boolean collected = false;
  PImage artifactImg;
 
  Artifact(float x, float y) {
    this.x = x;
    this.y = y;
    artifactImg = loadImage("tempArtifact.png");
  }
  
  void display() {
    if (!collected) {
      imageMode(CENTER);
      image(artifactImg, x, y, radius * 2, radius * 2.5);
    }
  }
}
