//
//  EmojiGame.swift
//  CS193p
//
//  Created by lym on 2021/4/12.
//

import Foundation

// model
struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>

    private var indexOfOneAndOnlyFaceUp: Int? {
        get {
            let faceUpIds = cards.indices.filter({ cards[$0].isFaceUp })
            return faceUpIds.count == 1 ? faceUpIds.first : nil
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }

    mutating func choose(card: Card) {
        let idx = cards.firstIndex(where: { $0.id == card.id })
        if let chooseIndex = idx, !cards[chooseIndex].isFaceUp, !cards[chooseIndex].isMatched {
            if let matchIdx = indexOfOneAndOnlyFaceUp {
                if cards[chooseIndex].content == cards[matchIdx].content {
                    cards[chooseIndex].isMatched = true
                    cards[matchIdx].isMatched = true
                }
                cards[chooseIndex].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUp = chooseIndex
            }
        }
    }

    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for index in 0 ..< numberOfPairsOfCards {
            let content = cardContentFactory(index)
            cards.append(Card(id: index * 2, isFaceUp: false, isMatched: false, content: content))
            cards.append(Card(id: index * 2 + 1, isFaceUp: false, isMatched: false, content: content))
        }
        cards.shuffle()
    }

    struct Card: Identifiable {
        var id: Int

        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }

        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }

        var content: CardContent
        
        
        // MARK: -

        var bonusTimeLimit: TimeInterval = 6

        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        var lastFaceUpDate: Date?

        var pastFaceUpTime: TimeInterval = 0

        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }

        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }

        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }

        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }

        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}
