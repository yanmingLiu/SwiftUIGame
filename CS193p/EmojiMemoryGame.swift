//
//  EmojiMemoryGame.swift
//  CS193p
//
//  Created by lym on 2021/4/12.
//

import SwiftUI

// view model
class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = creatMemoryGame()

    private static func creatMemoryGame() -> MemoryGame<String> {
        let emojis = ["👻", "💀", "☠️", "👽", "🕷"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { index in
            emojis[index]
        }
    }

    // MARK: - Access (通道)

    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }

    // MARK: - Intent (意图)

    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func reseatGame() {
        model = EmojiMemoryGame.creatMemoryGame()
    }
}
