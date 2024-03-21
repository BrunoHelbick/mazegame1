class FinishLine {
  float x, y;//position
  int size;//size
//intialize finish line at i j
  FinishLine(int i, int j, int size) {
    this.x = i * size;
    this.y = j * size;
    this.size = size;
  }

  void display() {//show the finish 
    fill(226, 205, 109); 
    rect(x, y, size, size);
  }

  boolean hit(float bx, float by, float r) {//checks if finish line has been hit
    return bx + r > x && bx - r < x + size && by + r > y && by - r < y + size;
  }
}
