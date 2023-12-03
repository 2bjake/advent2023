import Algorithms

struct Draw {
  private(set) var greenCount = 0
  private(set) var blueCount = 0
  private(set) var redCount = 0

  init(_ source: Substring) {
    let cubes = source.split(separator: ",")
    for cube in cubes {
      let count = Int(cube.firstMatch(of: /\d+/)!.output)!
      if cube.contains("green") {
        greenCount = count
      } else if cube.contains("blue") {
        blueCount = count
      } else if cube.contains("red") {
        redCount = count
      }
    }
  }
}

struct Game {
  let number: Int
  let draws: [Draw]

  init(_ source: Substring) {
    let parts = source.split(separator: ": ")
    let match = parts[0].firstMatch(of: /\d+/)
    number = Int(match!.output)!
    draws = parts[1].split(separator: ";").map(Draw.init)
  }

  private func max(by: (Draw) -> Int) -> Int {
    draws.map(by).max() ?? 0
  }

  var greenMax: Int { max(by: \.greenCount) }
  var blueMax: Int { max(by: \.blueCount) }
  var redMax: Int { max(by: \.redCount) }

}

public func partOne() {
  let games = input.split(separator: "\n").map(Game.init)
  let sum = games.filter {
    $0.redMax <= 12 && $0.greenMax <= 13 && $0.blueMax <= 14
  }.map(\.number).reduce(0, +)
  print(sum) // 2164
}

public func partTwo() {
  let games = input.split(separator: "\n").map(Game.init)
  let powerSum = games.map {
    $0.redMax * $0.blueMax * $0.greenMax
  }.reduce(0, +)
  print(powerSum)
}
