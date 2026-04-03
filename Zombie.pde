class Zombie {
  int state = 0;
  float x, y;
  float speed = 1.5;
  
  PImage zombieImg;
  int size = 90;
  
  float colliderRadius = 45;
  float detectionRadius = 200;
  float attackRange = 60;
  
  float damage = 10; // damage ???
  int attackCooldown = 60;
  int lastAttackFrame = 0; 
  
  void update(Player player) {
    float d = dist(x, y, player.x, player.y);
    
    if (d <attackRange) {
      attack(player);
    }
    else if (d < detectionRadius) {
      chase(player);
    }
  }
  
  // Chase state 
  void chase(Player player) {
   float angle = atan2(player.y - y, player.x - x);
   
   x += cos(angle) * speed;
   y += sin(angle) * speed;
  }
  
  // Attack state 
  void attack(Player player) {
    if (frameCount - lastAttackFrame > attackCooldown) {
      player.takeDamage(); 
      lastAttackFrame = frameCount; 
    }
  }
}
