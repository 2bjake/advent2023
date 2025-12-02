import Algorithms
import AdventUtilities
import HeapModule

struct GalaxyMap {
  let emptyColumnIndicies: [Int]
  let emptyRowIndicies: [Int]
  let grid: [[Character]]
  let galaxyPositions: [Position]
  let expansionAmount: Int

  init(_ source: String, expansionAmount: Int = 1) {
    let grid = source.split(separator: "\n").map(Array.init)
    self.expansionAmount = expansionAmount

    emptyColumnIndicies = (0..<grid.numberOfColumns).filter {
      grid.column(at: $0).allSatisfy { $0 == "." }
    }

    emptyRowIndicies = (0..<grid.numberOfRows).filter {
      grid[$0].allSatisfy { $0 == "." }
    }

    galaxyPositions = grid.allPositions.filter { grid[$0] == "#" }

    self.grid = grid
  }

  func manhattanDistance(from start: Position, to end: Position) -> Int {
    let preExpansionLength = difference(start, end)
    let (colMin, colMax) = [start.col, end.col].minAndMax()!
    let colExpansions = emptyColumnIndicies.count {
      (colMin...colMax).contains($0)
    }

    let (rowMin, rowMax) = [start.row, end.row].minAndMax()!
    let rowExpansions = emptyRowIndicies.count {
      (rowMin...rowMax).contains($0)
    }

    return preExpansionLength + colExpansions * expansionAmount + rowExpansions * expansionAmount
  }

  func moveCost(direction: Direction, to position: Position) -> Int {
    if (direction == .up || direction == .down) && emptyRowIndicies.contains(position.row) {
      return expansionAmount
    } else if (direction == .left || direction == .right) && emptyColumnIndicies.contains(position.col) {
      return expansionAmount
    } else {
      return 1
    }
  }
}

func difference(_ a: Position, _ b: Position) -> Int {
  absDiff(a.row, b.row) + absDiff(a.col, b.col)
}

//struct PositionCost: Comparable {
//  let position: Position
//  let cost: Int
//
//  static func < (lhs: PositionCost, rhs: PositionCost) -> Bool {
//    lhs.cost < rhs.cost
//  }
//}

//struct PositionHeapSet {
//  private var heap = Heap<PositionCost>()
//  private var set = Set<Position>()
//
//  mutating func insert(position: Position, cost: Int) {
//    set.insert(position)
//    heap.insert(PositionCost(position: position, cost: cost))
//  }
//
//  mutating func popMin() -> PositionCost? {
//    guard let positionCost = heap.popMin() else { return nil }
//    set.remove(positionCost.position)
//    return positionCost
//  }
//
//  func contains(_ position: Position) -> Bool {
//    set.contains(position)
//  }
//}

func distance(from start: Position, to goal: Position, in map: GalaxyMap) -> Int {
  var openSet = Set<Position>()
  openSet.insert(start)

  var gScore: [Position: Int] = [start: 0]

  var fScore = [Position: Int]()
  fScore[start] = map.manhattanDistance(from: start, to: goal)

  while !openSet.isEmpty {
    let current = openSet.min { a, b in
      fScore[a, default: .max] < fScore[b, default: .max]
    }!
    openSet.remove(current)

    if current == goal {
      return gScore[current]!
    }

    for direction in Direction.allCases {
      let neighbor = current.moved(direction)
      guard map.grid.isValidPosition(neighbor) else { continue }
      let tentativeScore = gScore[current]! + map.moveCost(direction: direction, to: neighbor)
      if tentativeScore < gScore[neighbor, default: Int.max] {
        gScore[neighbor] = tentativeScore
        fScore[neighbor] = tentativeScore + map.manhattanDistance(from: neighbor, to: goal)
        if !openSet.contains(neighbor) {
          openSet.insert(neighbor)
        }
      }
    }
  }
  fatalError("shouldn't happen")
}

public func partOne() {
  let map = GalaxyMap(input)
  let pairs = map.galaxyPositions.combinations(ofCount: 2)

  let lengthsSum = pairs.map {
    map.manhattanDistance(from: $0[0], to: $0[1])
  }.reduce(0, +)
  print(lengthsSum) // 9536038
}

public func partTwo() {
  let map = GalaxyMap(input, expansionAmount: 1_000_000)
  let pairs = map.galaxyPositions.combinations(ofCount: 2)
  print(pairs.count)

  var result = 0
  var i = 0
  for pair in pairs {
    result += distance(from: pair[0], to: pair[1], in: map)
    i += 1
    if i % 1000 == 0 {
      print("pair \(i) of \(pairs.count)")
    }
  }

  print(result)

//    .map {
//    distance(from: $0[0], to: $0[1], in: map)
//  }.reduce(0, +)
//  print(lengthSum)
}
