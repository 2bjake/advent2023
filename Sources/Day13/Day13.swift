import Algorithms
import AdventUtilities

func makeGrids(_ str: String) -> [[[Character]]] {
  str.split(separator: "\n\n").map { patternStr in
    patternStr.split(separator: "\n").map(Array.init)
  }
}

func isReflection(_ grid: ArraySlice<[Character]>) -> Bool {
  guard grid.count.isMultiple(of: 2) else { return false }
  var grid = grid
  while let first = grid.first, let last = grid.last, first == last {
    grid = grid.dropFirst()
    grid = grid.dropLast()
  }

  return grid.isEmpty
}

func findReflectionPlace(_ grid: [[Character]]) -> (Int, Int)? {
  var dropCount = 0
  var grid = grid[...]
  while grid.count > 1 {
    if grid.first == grid.last {
      if isReflection(grid) {
        return (grid.count / 2, grid.count / 2 + dropCount)
      }
    }
    grid = grid.dropLast()
    dropCount += 1
  }
  return nil
}

func findHorizontalReflectionValue(_ grid: [[Character]]) -> Int? {
  if let (front, _) = findReflectionPlace(grid) { return front }
  if let (_, back) = findReflectionPlace(grid.reversed()) { return back }
  return nil
}

func findReflectionValue(_ grid: [[Character]]) -> Int? {
  if let horizontalValue = findHorizontalReflectionValue(grid) {
    return horizontalValue * 100
  } else if let verticalValue = findHorizontalReflectionValue(grid.transpose()) {
    return verticalValue
  } else {
    return nil
  }
}

public func partOne() {
  print(makeGrids(input).compactMap(findReflectionValue).reduce(0, +)) // 334889
}

func findReflectionPlaces(_ grid: [[Character]]) -> [(Int, Int)] {
  var result = [(Int, Int)]()
  var dropCount = 0
  var grid = grid[...]
  while grid.count > 1 {
    if grid.first == grid.last {
      if isReflection(grid) {
        result.append((grid.count / 2, grid.count / 2 + dropCount))
      }
    }
    grid = grid.dropLast()
    dropCount += 1
  }
  return result
}

func findHorizontalReflectionValues(_ grid: [[Character]]) -> [Int] {
  var result = [Int]()
  result.append(contentsOf: findReflectionPlaces(grid).map { $0.0 })
  result.append(contentsOf: findReflectionPlaces(grid.reversed()).map { $0.1 })
  return result
}

func findReflectionValues(_ grid: [[Character]]) -> [Int] {
  var result = [Int]()
  result.append(contentsOf: findHorizontalReflectionValues(grid).map { $0 * 100 })
  result.append(contentsOf: findHorizontalReflectionValues(grid.transpose()))
  return result
}

func findSmudgeFixValue(_ grid: [[Character]]) -> Int {
  let origValue = findReflectionValue(grid)
  for position in grid.allPositions {
    var grid = grid

    if grid[position] == "." {
      grid[position] = "#"
    } else {
      grid[position] = "."
    }

    if let value = findReflectionValues(grid).first(where: { $0 != origValue! }) {
      return value
    }
  }
  fatalError("no smudge fix found")
}

public func partTwo() {
//  var result = 0
//  let grids = makeGrids(input)
//  print(grids.count)
//  for i in grids.indices {
//    print(i)
//    result += findSmudgeFixValue(grids[i])
//  }
  print(makeGrids(input).map(findSmudgeFixValue).reduce(0, +))
}

//public func partTwo() {
//  let grids = makeGrids(input)
//  var grid = grids[6] // [7][11
//
//  print(findSmudgeFixValue(grid))
//}
