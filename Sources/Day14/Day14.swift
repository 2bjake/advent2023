import Algorithms
import AdventUtilities

func moveRockUp(at position: Position, in grid: inout [[Character]]) {
  var endPosition = position
  while grid.element(atPosition: endPosition.moved(.up)) == Character(".") {
    endPosition.move(.up)
  }
  grid[position] = "."
  grid[endPosition] = "O"
}

func tiltUp(grid: [[Character]]) -> [[Character]] {
  var grid = grid

  for i in grid.indices {
    for j in grid[i].indices {
      if grid[i][j] == "O" {
        moveRockUp(at: Position(i, j), in: &grid)
      }
    }
  }

  return grid
}

func printGrid(_ grid: [[Character]]) {
  for line in grid {
    print(String(line))
  }
}

func calcNorthLoad(_ grid: [[Character]]) -> Int {
  let height = grid.count
  let rockPositions = grid.allPositions.filter {
    grid.element(atPosition: $0) == "O"
  }

  return rockPositions.map { height - $0.row }.reduce(0, +)
}

public func partOne() {
  let grid = input.split(separator: "\n").map(Array.init)
  let newGrid = tiltUp(grid: grid)
  print(calcNorthLoad(newGrid))
}

public func partTwo() {

}
