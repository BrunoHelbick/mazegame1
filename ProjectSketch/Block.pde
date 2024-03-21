
class Block {
  boolean isVisible = true;
  float x, y, w, h;//position and dimensions of wall
  //intializes new block
  Block(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void display() {//returns if not visible otherwise draws the block
    if (!isVisible) return;
    fill(194, 178, 143);
    rect(x, y, w, h);
  }

  int hit(float bx, float by, float r) {//to check if ball hits wall
    if (bx + r > x - WALL_THICKNESS / 2 && bx - r < x + w + WALL_THICKNESS / 2 && 
        by + r > y - WALL_THICKNESS / 2 && by - r < y + h + WALL_THICKNESS / 2) {
      float closestX = constrain(bx, x, x + w);//find closest point to the wall on the ball
      float closestY = constrain(by, y, y + h);
      float distanceX = bx - closestX;//distance from closest point on ball
      float distanceY = by - closestY;
      if (abs(distanceY) > abs(distanceX)) {
        return 2;//vertical collision
      } else {
        return 1;//horizontal collision
      }
    }
    return 0;//no collision
  }
}
