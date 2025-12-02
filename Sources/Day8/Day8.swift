import Algorithms

func parse(_ str: String) -> (directions: [Character], map: [String: (String, String)]) {
  let parts = str.split(separator: "\n\n")
  let directions = Array(parts[0])

  let map: [String: (String, String)] = parts[1].split(separator: "\n").reduce(into: [:]) { result, substr in
    let source = String(substr.prefix(3))
    let left = String(substr.dropFirst(7).prefix(3))
    let right = String(substr.dropFirst(12).prefix(3))
    result[source] = (left, right)
  }

  return (directions, map)
}

public func partOne() {

  let (directions, map) = parse(input)

  var stepCount = 0
  var cur = "AAA"
  var curDirections = directions
  while cur != "ZZZ" {
    stepCount += 1
    if curDirections.isEmpty {
      curDirections = directions
    }

    let direction = curDirections.removeFirst()
    if direction == "L" {
      cur = map[cur]!.0
    } else {
      cur = map[cur]!.1
    }
  }

  print(stepCount) // 17287
}

public func partTwo() {
  let (directions, map) = parse(input)

  var cur = map.keys.filter { $0.last == "A" }

  var stepCount = 0
  var curDirections = directions
  while !cur.allSatisfy({ $0.last == "Z" }) {
    stepCount += 1
    if curDirections.isEmpty {
      curDirections = directions
    }

    let direction = curDirections.removeFirst()
    if direction == "L" {
      cur = cur.map { map[$0]!.0 }
    } else {
      cur = cur.map { map[$0]!.1 }
    }
  }

  print(stepCount)

}
