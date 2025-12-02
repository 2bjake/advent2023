import Algorithms
import AdventUtilities

enum HandType: Comparable {
  case highCard
  case onePair
  case twoPair
  case threeOfAKind
  case fullHouse
  case fourOfAKind
  case fiveOfAKind

  init?(_ shape: [Int]) {
    switch shape {
      case [1, 1, 1, 1, 1]: self = .highCard
      case [1, 1, 1, 2]: self = .onePair
      case [1, 2, 2]: self = .twoPair
      case [1, 1, 3]: self = .threeOfAKind
      case [2, 3]: self = .fullHouse
      case [1, 4]: self = .fourOfAKind
      case [5]: self = .fiveOfAKind
      default: return nil
    }
  }
}

protocol GameRules {
  associatedtype Card: Comparable
  static func handType(_ cards: [Card]) -> HandType
}

struct Hand<Rules: GameRules>: Comparable {
  let cards: [Rules.Card]
  let bid: Int

  static func < (lhs: Hand, rhs: Hand) -> Bool {
    if Rules.handType(lhs.cards) < Rules.handType(rhs.cards) { return true }
    if Rules.handType(lhs.cards) > Rules.handType(rhs.cards) { return false }

    for i in 0..<5 {
      guard lhs.cards[i] != rhs.cards[i] else { continue }
      return lhs.cards[i] < rhs.cards[i]
    }
    return false
  }
}

public func partOne() {
  func parse(_ source: Substring) -> Hand<PartOneGameRules> {
    let cards = source.prefix(5).compactMap(PartOneCard.init)
    let bid = Int(source.dropFirst(6))!
    return Hand(cards: cards, bid: bid)
  }
  let orderedHands = input.split(separator: "\n").map(parse).sorted()
  let result = (0..<orderedHands.count).map { ($0 + 1) * orderedHands[$0].bid }.reduce(0, +)
  print(result) // 248453531
}

public func partTwo() {
  func parse(_ source: Substring) -> Hand<PartTwoGameRules> {
    let cards = source.prefix(5).compactMap(PartTwoCard.init)
    let bid = Int(source.dropFirst(6))!
    return Hand(cards: cards, bid: bid)
  }
  let orderedHands = input.split(separator: "\n").map(parse).sorted()
  let result = (0..<orderedHands.count).map { ($0 + 1) * orderedHands[$0].bid }.reduce(0, +)
  print(result) // 248781813
}
