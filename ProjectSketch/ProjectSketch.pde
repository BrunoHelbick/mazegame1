int cols, rows;
int cellSize = 40;
Cell[][] grid;
ArrayList<Cell> stack = new ArrayList<Cell>();
float angle = 0;
int mazeWidth;
int mazeHeight;
boolean movingRight = false;
boolean movingLeft = false;
float ballX, ballY;
float ballVelocityX = 1;
float ballVelocityY = 1;
float gravity = 0.1; 
int WINDOW_WIDTH = 1000; 
int WINDOW_HEIGHT = 1000; 
int BALL_RADIUS = 5;
int WALL_THICKNESS = 5;
int chosenCorner;
float MAX_VELOCITY = 4;
RedCell redCell;
ArrayList<RedCell> redCells = new ArrayList<RedCell>();
int numRedCells = 1; 
FinishLine finishLine;

void setup() {
  size(1000,1000);
  initializeGame();//set up the game
}

void draw() {
  background(220,100,100);//set background
  fill(131, 183, 153);
  strokeWeight(0);
  rect(0+width/2,0,500,1000);//set background

  float gravityX = gravity * sin(angle);//change gravity depending on the current screen rotation
  float gravityY = gravity * cos(angle);

  ballVelocityX += gravityX;//add effect of gravity
  ballVelocityY += gravityY;

  ballX += ballVelocityX;
  ballY += ballVelocityY;
  ballVelocityX = constrain(ballVelocityX, -MAX_VELOCITY, MAX_VELOCITY);//constrain the maximum velocity
  ballVelocityY = constrain(ballVelocityY, -MAX_VELOCITY, MAX_VELOCITY);
  

  float dampening = 0.7; //gravity dampening when hit a wall
  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      for (Block wall : grid[i][j].walls) {
        int hitResult = wall.hit(ballX, ballY, BALL_RADIUS);//check if ball has hit current wall
        if (wall.isVisible && hitResult > 0) {
          if (hitResult == 1) { //horizontal collision
            ballVelocityX = -ballVelocityX * dampening;
            ballX += 2 * ballVelocityX;
          } else if (hitResult == 2) { //vertical collision
            ballVelocityY = -ballVelocityY * dampening;
            ballY += 2 * ballVelocityY;
          }
        }
      }
    }
  }
  

  
  if (finishLine.hit(ballX, ballY, BALL_RADIUS)) {
    resetGame(); //reset game if ball has hit finish
  }

  translate(width / 2, height / 2);//translate to centre of screen before it rotates
  
  if (movingRight) {//rotate right
    angle += 0.02;
  }
  if (movingLeft) {//rotate left
    angle -= 0.02;
  }
  rotate(angle);
  fill(228, 216, 180);//maze background colour 
  rect(0 - mazeWidth / 2, -mazeHeight / 2, mazeWidth, mazeHeight);

  translate(-mazeWidth / 2, -mazeHeight / 2);//move maze back
  noStroke();
  finishLine.display(); //show finish 
  strokeWeight(7);
  for (RedCell redCell : redCells) {//reset ball if hits a redcell and show redcell
    if (redCell.hit(ballX, ballY, BALL_RADIUS)) {
      ballX = 175;  
      ballY = 175;
    }
    redCell.display();
  }
  for (int j = 0; j < rows; j++) {//show the cells on the grid
    for (int i = 0; i < cols; i++) {
      grid[i][j].show();
    }
  }
  
  generateMaze();//generate next step of the maze
  fill(255, 0, 0);//draw the ball
  ellipse(ballX, ballY, BALL_RADIUS * 2, BALL_RADIUS * 2);
}

void initializeGame() {
  ballX = 175;
  ballY = 175;//intial ball coords

  cols = floor((width / 2) / cellSize);//number of col/rows
  rows = floor((height / 2) / cellSize);
  grid = new Cell[cols][rows];//initalize the grid for maze
  mazeWidth = cols * cellSize;
  mazeHeight = rows * cellSize;//calculate width/height of maze
  for (int j = 0; j < rows; j++) {//fill the grid with cells
    for (int i = 0; i < cols; i++) {
      grid[i][j] = new Cell(i, j);
    }
  }
  strokeCap(SQUARE);
  stack.add(grid[0][0]);//start with top left cell
  frameRate(60);
  redCells.clear(); //het rid of last games redcells
  for (int i = 0; i < numRedCells; i++) {//create new redcells
    int redCellI = int(random(cols));
    int redCellJ = int(random(rows));
    redCells.add(new RedCell(redCellI, redCellJ, cellSize));
  }

  chosenCorner = int(random(4)); //randomly choose a corner for finish line
  int[] finishLinePosition = getFinishLinePosition(chosenCorner, cols, rows);//calls get finish line position function
  finishLine = new FinishLine(finishLinePosition[0], finishLinePosition[1], cellSize);
}

int[] getFinishLinePosition(int chosenCorner, int cols, int rows) {//determines the values of finishLineI and finishLineJ based on chosen corner
  int finishLineI, finishLineJ;
  if (chosenCorner == 0) {
    finishLineI = 0;
    finishLineJ = 0;
  } else if (chosenCorner == 1) {
    finishLineI = cols - 1;
    finishLineJ = 0;
  } else if (chosenCorner == 2) {
    finishLineI = 0;
    finishLineJ = rows - 1;
  } else {
    finishLineI = cols - 1;
    finishLineJ = rows - 1;
  }
  return new int[]{finishLineI, finishLineJ};//returns answer
}

void generateMaze() {//generates maze using depth-first search algorithm
  if (stack.size() > 0) {//continue generating if there are still cells in the stack
    Cell current = stack.get(stack.size() - 1);//get current cell
    current.visited = true;
    Cell next = current.checkNeighbors();
    if (next != null) {
      stack.add(next);//add neighbour to stack
      removeWalls(current, next);//remove walls between current and neighbour cell
      next.visited = true;
    } else {
      stack.remove(stack.size() - 1);//if there are no more neighhbours remove the cell from the stack array
    }
  } 
}

void removeWalls(Cell a, Cell b) {
  int x = a.i - b.i;//horizontal disance between cells
  if (x == 1) {
    a.walls[3].isVisible = false;// Remove left wall of cell a
    b.walls[1].isVisible = false;// Remove right wall of cell b
  } else if (x == -1) {
    a.walls[1].isVisible = false;// Remove right wall of cell a
    b.walls[3].isVisible = false;// Remove left wall of cell b
  }
  int y = a.j - b.j;//vertical distance between cells
  if (y == 1) {
    a.walls[0].isVisible = false;// Remove top wall of cell a
    b.walls[2].isVisible = false; //remove bottom wall of cell b
  } else if (y == -1) {
    a.walls[2].isVisible = false;//remove bottom wall of cell a
    b.walls[0].isVisible = false;//remove top wall of cell b
  }
}

void resetGame() {
  numRedCells++;//increase number of red cells by one
  initializeGame();
}

void keyPressed() {
  if (key == 'd') {
    movingRight = true;
  }
  if (key == 'a') {
    movingLeft = true;
  }
}

void keyReleased() {
  if (key == 'd') {
    movingRight = false;
  }
  if (key == 'a') {
    movingLeft = false;
  }
}
