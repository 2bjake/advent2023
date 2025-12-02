import Algorithms
import AdventUtilities

func extractInts(_ s: Substring) -> [Int] {
  s.matches(of: /\d+/).map(\.output).compactMap(Int.init)
}

func waysToWin(time: Int, distance: Int) -> Int {
  (0...time).map { (time - $0) * $0 }.filter { $0 > distance }.count
}

func solve(_ str: String) {
  let ints = str.split(separator: "\n").map(extractInts)
  let result = zip(ints[0], ints[1]).map(waysToWin).reduce(1, *)
  print(result)
}

public func partOne() {
  solve(input) // 1155175
}

public func partTwo() {
  solve(input.replacingOccurrences(of: " ", with: "")) // 35961505
}
