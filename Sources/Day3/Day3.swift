import Algorithms
import AdventUtilities

struct Number: Hashable {
  let start: Position
  let end: Position

  var positions: PositionSequence { .init(from: start, to: end) }
}

struct PartFinder {
  let grid: [[Character]]
  let positionToNumber: [Position: Number]

  var symbolPositions: [Position]  {
    grid.allPositions.filter {
      !grid[$0].isNumber && grid[$0] != "."
    }
  }

  init(_ source: String) {
    grid = source.split(separator: "\n").map { $0.map { $0 } }

    positionToNumber = Self.makeNumbers(grid: grid).reduce(into: [:]) { result, number in
      for position in number.positions {
        result[position] = number
      }
    }
  }

  private static func makeNumbers(grid: [[Character]]) -> [Number] {
    var numbers = [Number]()
    for rowNum in 0..<grid.numberOfRows {
      var startPosition: Position?

      for position in grid.positionsInRow(rowNum) {
        if startPosition == nil && grid[position].isNumber {
          startPosition = position
        } else if let start = startPosition, !grid[position].isNumber {
          numbers.append(.init(start: start, end: position.moved(.left)))
          startPosition = nil
        }
      }

      if let start = startPosition {
        numbers.append(.init(start: start, end: Position(rowNum, grid.numberOfColumns - 1)))
      }
    }
    return numbers
  }

  func adjacentNumbers(to pos: Position) -> Set<Number> {
    var numbers: Set<Number> = []

    for adjacents in grid.adjacentPositions(of: pos, includingDiagonals: true) {
      if let number = positionToNumber[adjacents] {
        numbers.insert(number)
      }
    }

    return numbers
  }

  func value(of num: Number) -> Int {
    var val = 0
    for position in num.positions {
      val *= 10
      val += Int(grid[position])!
    }
    return val
  }
}

public func partOne() {
  let partFinder = PartFinder(input)

  let partNums: Set<Number> = partFinder.symbolPositions.reduce(into: []) { result, position in
    result.formUnion(partFinder.adjacentNumbers(to: position))
  }

  print(partNums.map { partFinder.value(of: $0) }.reduce(0, +)) // 546312

}

public func partTwo() {
  let partFinder = PartFinder(input)

  var sum = 0
  for pos in partFinder.symbolPositions where partFinder.grid[pos] == "*" {
    let adjacentNums = partFinder.adjacentNumbers(to: pos)
    if adjacentNums.count == 2 {
      let ratio = adjacentNums.map { partFinder.value(of: $0) }.reduce(1, *)
      sum += ratio
    }
  }

  print(sum) // 87449461
}

