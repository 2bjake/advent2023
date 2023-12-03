import AdventUtilities

func getNumber<S: StringProtocol>(_ s: S) -> Int {
  let first = Int(s.first(where: \.isNumber)!)!
  let last = Int(s.last(where: \.isNumber)!)!
  return first * 10 + last
}

public func partOne() {
  let result = input.split(separator: "\n").map(getNumber).reduce(0, +)
  print(result) // 54990
}

func getNumberOrText(_ s: Substring) -> Int {
  let first = getFirstNumberOrText(s)
  let last = getLastNumberOrText(s)
  return first * 10 + last
}

let nums: [Substring: Int] = [
  "one": 1,
  "two": 2,
  "three": 3,
  "four": 4,
  "five": 5,
  "six": 6,
  "seven": 7,
  "eight": 8,
  "nine": 9
]

func getFirstNumberOrText(_ s: Substring) -> Int {
  let regex = /\d|one|two|three|four|five|six|seven|eight|nine/
  let match = s.firstMatch(of: regex)!

  if match.output.count == 1 {
    return Int(match.output)!
  } else {
    return nums[match.output]!
  }
}

func getLastNumberOrText(_ s: Substring) -> Int {
  var s = s
  while let last = s.last {
    if last.isNumber {
      return Int(last)!
    } else {
      for entry in nums {
        if s.hasSuffix(entry.key) {
          return entry.value
        }
      }
      s = s.dropLast()
    }
  }
  fatalError("this shouldn't happen")
}

public func partTwo() {
  let result = input.split(separator: "\n").map(getNumberOrText).reduce(0, +)
  print(result) // 54473
}
