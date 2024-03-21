class RedCell {
  float x, y;
  int size;
  boolean isVisible;  

  RedCell(int i, int j, int size) {
    this.x = i * size;
    this.y = j * size;
    this.size = size;
    this.isVisible = true;  
  }

  void display() {
    if (isVisible) {  
      fill(220, 100, 100, 120);
      rect(x, y, size, size);
    }
  }

  boolean hit(float bx, float by, float r) {//if its visible and ball is on the coords return true and make the rect no longer visible
    if (isVisible && bx + r > x && bx - r < x + size && by + r > y && by - r < y + size) {
      isVisible = false;  
      return true;
    }
    return false;
  }
}
