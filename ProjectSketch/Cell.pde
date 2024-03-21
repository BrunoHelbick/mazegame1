
class Cell {
  int i, j;//grid position
  Block[] walls = new Block[4];//array of 4 walls
  boolean visited = false;//show if the cell has been when generating the maze

  Cell(int i, int j) {//intializing a new cell at i and j 
    this.i = i;//column in the grid
    this.j = j;//cell in the grid
    int x = i * cellSize;//calculates actual position based on where it is on the grid
    int y = j * cellSize;
    float extend = 2.5; // to get rid of inverted corners
    walls[0] = new Block(x - extend/2, y - WALL_THICKNESS / 2, cellSize + extend, WALL_THICKNESS); //top wall
    walls[1] = new Block(x + cellSize - WALL_THICKNESS / 2, y - extend/2, WALL_THICKNESS, cellSize + extend); //right wall
    walls[2] = new Block(x - extend/2, y + cellSize - WALL_THICKNESS / 2, cellSize + extend, WALL_THICKNESS); //bottom wall
    walls[3] = new Block(x - WALL_THICKNESS / 2, y - extend/2, WALL_THICKNESS, cellSize + extend); //left wall

  }

  void show() {//show each wall in the cell
    for (Block wall : walls) {
      wall.display();
    }
  }

  Cell checkNeighbors() {//checking for unvisited neighbours
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    if (i > 0 && !grid[i - 1][j].visited) neighbors.add(grid[i - 1][j]);//left neighbour
    if (i < cols - 1 && !grid[i + 1][j].visited) neighbors.add(grid[i + 1][j]);//right neighbour
    if (j > 0 && !grid[i][j - 1].visited) neighbors.add(grid[i][j - 1]);//top neighbour
    if (j < rows - 1 && !grid[i][j + 1].visited) neighbors.add(grid[i][j + 1]);//bottom neightbour
    if (neighbors.size() > 0) {//if theres an unvisited neighbour 
      int r = int(random(neighbors.size()));//return a randomly selected unvisited neighbour
      return neighbors.get(r);
    } else {
      return null;//no unvisited neighbours
    }
  }
}
