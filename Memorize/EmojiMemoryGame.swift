//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Pierre-Hugues Oger on 07/05/2023.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = ["🚗", "🚕", "🚙", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛴", "🚲", "🏍️", "🛺",   "🚌", "🚁", "🛵", "🚂", "🚀", "🛸", "⛵️"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 6) { pairIndex in emojis[pairIndex]}
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: [Card] {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
}




