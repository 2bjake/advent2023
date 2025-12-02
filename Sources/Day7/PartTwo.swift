enum PartTwoCard: Comparable {
  case joker, two, three, four, five, six, seven, eight, nine, ten, queen, king, ace

  init?(rawValue: Character) {
    switch rawValue {
      case "J": self = .joker
      case "2": self = .two
      case "3": self = .three
      case "4": self = .four
      case "5": self = .five
      case "6": self = .six
      case "7": self = .seven
      case "8": self = .eight
      case "9": self = .nine
      case "T": self = .ten
      case "Q": self = .queen
      case "K": self = .king
      case "A": self = .ace
      default: return nil
    }
  }
}

struct PartTwoGameRules: GameRules {
  static func handType(_ cards: [PartTwoCard]) -> HandType {
    var cardToCount = cards.reduce(into: [PartTwoCard: Int]()) { result, card in
      result[card, default: 0] += 1
    }

    let jokerCount = cardToCount[.joker] ?? 0
    if jokerCount > 0 && jokerCount != 5  {
      cardToCount[.joker] = nil
    }

    var shape = cardToCount.values.sorted()
    if jokerCount != 5 {
      shape[shape.count - 1] += jokerCount
    }
    return HandType(shape)!
  }
}
