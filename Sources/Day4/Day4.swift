import Algorithms
import AdventUtilities
import Foundation

func setOfNumbers(_ line: Substring) -> Set<Int> {
  Set(line.matches(of: /\d+/).map { Int($0.output)! })
}

func matchCount(_ line: Substring) -> Int {
  let parts = line.split(separator: ":")
  let sets = parts[1].split(separator: "|").map(setOfNumbers)
  return sets[0].intersection(sets[1]).count
}

func score(_ matchCount: Int) -> Int {
  guard matchCount > 0 else { return 0 }
  return Int(pow(2, Double(matchCount - 1)))
}

public func partOne() {
  let sum = input
    .split(separator: "\n")
    .map(matchCount)
    .map(score)
    .reduce(0, +)

  print(sum) // 17782

}

func add(amount: Int, toElementsAfter idx: Int, length: Int, in array: inout [Int]) {
  guard length > 0 else { return }
  for i in 1...length where idx + i < array.count {
    array[idx + i] += amount
  }
}

public func partTwo() {
  let matchCounts = input.split(separator: "\n").map(matchCount)
  var cardCounts = Array(repeating: 1, count: matchCounts.count)
  for i in 0..<matchCounts.count {
    add(amount: cardCounts[i], toElementsAfter: i, length: matchCounts[i], in: &cardCounts)
  }
  print(cardCounts.reduce(0, +)) // 8477787
}
