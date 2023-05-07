//
//  EmojiMemomryGame.swift
//  Memorize
//
//  Created by Pierre-Hugues Oger on 07/05/2023.
//

import SwiftUI

class EmojiMemoryGame {
    static let emojis = ["🚗", "🚕", "🚙", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛴", "🚲", "🏍️", "🛺",   "🚌", "🚁", "🛵", "🚂", "🚀", "🛸", "⛵️"]
    
    private var model = MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in emojis[pairIndex]}
    
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
}
