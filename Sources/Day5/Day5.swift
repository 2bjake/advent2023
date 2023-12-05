import Algorithms
import AdventUtilities

struct RangeMap: Comparable {
  let sourceRange: Range<Int>
  let destinationLowerBound: Int

  static func < (lhs: RangeMap, rhs: RangeMap) -> Bool {
    lhs.sourceRange.lowerBound < rhs.sourceRange.lowerBound
  }

  func destination(for sourceValue: Int) -> Int? {
    guard sourceRange.contains(sourceValue) else { return nil }
    return sourceValue - sourceRange.lowerBound + destinationLowerBound
  }

  init?(s: Substring) {
    let ints = extractInts(s)
    guard ints.count == 3 else { return nil }
    destinationLowerBound = ints[0]
    sourceRange = ints[1]..<(ints[1] + ints[2])
  }
}

func extractInts(_ s: Substring) -> [Int] {
  s.matches(of: /\d+/).map(\.output).compactMap(Int.init)
}

func parseInput() -> (seeds: [Int], mapLists: [[RangeMap]]) {
  var section = input.split(separator: "\n\n")
  let seeds = extractInts(section.removeFirst())

  let mapLists = section.map {
    $0.split(separator: "\n").compactMap(RangeMap.init).sorted()
  }
  return (seeds, mapLists)
}

func mapValue(_ srcValue: Int, using mapList: [RangeMap]) -> Int {
  for map in mapList {
    if srcValue < map.sourceRange.lowerBound {
      return srcValue
    } else if let destValue = map.destination(for: srcValue) {
      return destValue
    }
  }
  return srcValue
}

func seedToDestination(seed: Int, mapLists: [[RangeMap]]) -> Int {
  var cur = seed
  for mapList in mapLists {
    cur = mapValue(cur, using: mapList)
  }
  return cur
}

public func partOne() {
  let (seeds, mapLists) = parseInput()

  let destinations = seeds.map {
    seedToDestination(seed: $0, mapLists: mapLists)
  }

  print(destinations.min()!) // 173706076
}

func mapRange(_ srcRange: Range<Int>, using mapList: [RangeMap]) -> [Range<Int>] {
  var result = [Range<Int>]()

  var remainingRange = srcRange

  for map in mapList where !remainingRange.isEmpty {
    let (before, overlap, after) = remainingRange.partition(by: map.sourceRange)
    if let before { result.append(before) }
    if let overlap {
      let mappedLowerBound = overlap.lowerBound - map.sourceRange.lowerBound + map.destinationLowerBound
      result.append(mappedLowerBound..<(mappedLowerBound + overlap.count))
    }

    remainingRange = after ?? .empty
  }

  if !remainingRange.isEmpty {
    result.append(remainingRange)
  }

  return result
}

func seedRangesToDestinationRanges(seedRanges: [Range<Int>], mapLists: [[RangeMap]]) -> [Range<Int>] {
  var curRanges = seedRanges
  for mapList in mapLists {
    curRanges = curRanges.flatMap { mapRange($0, using: mapList) }
  }
  return curRanges
}

public func partTwo() {
  let (seedInput, mapLists) = parseInput()
  let seedRanges = seedInput.chunks(ofCount: 2).map {
    $0.first!..<($0.first! + $0.last!)
  }

  let destRanges = seedRangesToDestinationRanges(seedRanges: seedRanges, mapLists: mapLists)
  print(destRanges.map(\.lowerBound).min()!) // 11611182
}
