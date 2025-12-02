enum PartOneCard: Comparable {
  case two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace

  init?(rawValue: Character) {
    switch rawValue {
      case "2": self = .two
      case "3": self = .three
      case "4": self = .four
      case "5": self = .five
      case "6": self = .six
      case "7": self = .seven
      case "8": self = .eight
      case "9": self = .nine
      case "T": self = .ten
      case "J": self = .jack
      case "Q": self = .queen
      case "K": self = .king
      case "A": self = .ace
      default: return nil
    }
  }
}

struct PartOneGameRules: GameRules {
  static func handType(_ cards: [PartOneCard]) -> HandType {
    let shape = cards.reduce(into: [PartOneCard: Int]()) { result, card in
      result[card, default: 0] += 1
    }.values.sorted()
    return HandType(shape)!
  }
}

