class AStarPathfinder {
  int gridSize;
  int cols, rows;
  boolean[][] blockedGrid;
  ArrayList<Tree> trees;

  AStarPathfinder(int gridSize, ArrayList<Tree> trees) {
    this.gridSize = gridSize;
    this.trees = trees;
    this.cols = width / gridSize;
    this.rows = height / gridSize;
    blockedGrid = new boolean[cols][rows];
    buildBlockedGrid();
  }

  void buildBlockedGrid() {
    for (int cx = 0; cx < cols; cx++) {
      for (int cy = 0; cy < rows; cy++) {
        float px = cx * gridSize + gridSize * 0.5;
        float py = cy * gridSize + gridSize * 0.5;

        boolean blocked = false;

        for (Tree tree : trees) {
          if (dist(px, py, tree.position.x, tree.position.y) < tree.colliderRadius + 20) {
            blocked = true;
            break;
          }
        }

        blockedGrid[cx][cy] = blocked;
      }
    }
  }

  ArrayList<PVector> findPath(float startX, float startY, float endX, float endY) {
    int startCol = constrain(int(startX / gridSize), 0, cols - 1);
    int startRow = constrain(int(startY / gridSize), 0, rows - 1);
    int endCol = constrain(int(endX / gridSize), 0, cols - 1);
    int endRow = constrain(int(endY / gridSize), 0, rows - 1);

    if (blockedGrid[startCol][startRow] || blockedGrid[endCol][endRow]) return null;

    ArrayList<AStarNode> openSet = new ArrayList<AStarNode>();
    boolean[][] closed = new boolean[cols][rows];
    AStarNode[][] nodeGrid = new AStarNode[cols][rows];

    AStarNode startNode = new AStarNode(startCol, startRow);
    startNode.g = 0;
    startNode.h = heuristic(startCol, startRow, endCol, endRow);
    startNode.f = startNode.g + startNode.h;

    openSet.add(startNode);
    nodeGrid[startCol][startRow] = startNode;

    while (openSet.size() > 0) {
      int bestIndex = 0;
      for (int i = 1; i < openSet.size(); i++) {
        if (openSet.get(i).f < openSet.get(bestIndex).f) {
          bestIndex = i;
        }
      }

      AStarNode current = openSet.get(bestIndex);

      if (current.col == endCol && current.row == endRow) {
        return reconstructPath(current);
      }

      openSet.remove(bestIndex);
      closed[current.col][current.row] = true;

      int[][] dirs = {
        {1, 0}, {-1, 0}, {0, 1}, {0, -1}
      };

      for (int i = 0; i < dirs.length; i++) {
        int nc = current.col + dirs[i][0];
        int nr = current.row + dirs[i][1];

        if (nc < 0 || nr < 0 || nc >= cols || nr >= rows) continue;
        if (blockedGrid[nc][nr]) continue;
        if (closed[nc][nr]) continue;

        float tentativeG = current.g + 1;

        AStarNode neighbor = nodeGrid[nc][nr];
        if (neighbor == null) {
          neighbor = new AStarNode(nc, nr);
          nodeGrid[nc][nr] = neighbor;
        }

        boolean inOpen = openSet.contains(neighbor);
        if (!inOpen || tentativeG < neighbor.g) {
          neighbor.parent = current;
          neighbor.g = tentativeG;
          neighbor.h = heuristic(nc, nr, endCol, endRow);
          neighbor.f = neighbor.g + neighbor.h;

          if (!inOpen) {
            openSet.add(neighbor);
          }
        }
      }
    }

    return null;
  }

  float heuristic(int c1, int r1, int c2, int r2) {
    return abs(c1 - c2) + abs(r1 - r2);
  }

  ArrayList<PVector> reconstructPath(AStarNode endNode) {
    ArrayList<PVector> path = new ArrayList<PVector>();
    AStarNode current = endNode;

    while (current != null) {
      float px = current.col * gridSize + gridSize * 0.5;
      float py = current.row * gridSize + gridSize * 0.5;
      path.add(0, new PVector(px, py));
      current = current.parent;
    }

    return path;
  }
}

class AStarNode {
  int col, row;
  float g = 999999;
  float h = 0;
  float f = 0;
  AStarNode parent;

  AStarNode(int col, int row) {
    this.col = col;
    this.row = row;
  }
}
