class Food {
  float x, y;
  float radius = 30;
  boolean collected = false;
  PImage foodImg;

  Food(float x, float y) {
    this.x = x;
    this.y = y;
    foodImg = loadImage("foodcan.png");
  }

  void display() {
    if (!collected) {
      imageMode(CENTER);
      image(foodImg, x, y, radius*2, radius*2);
    }
  }
}
