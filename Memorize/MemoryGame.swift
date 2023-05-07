//
//  MemoryGame.swift
//  Memorize
//
//  Created by Pierre-Hugues Oger on 07/05/2023.
//

import Foundation

struct MemoryGame<CardContent> {
    private(set) var cards = [Card]()
    
    func choose(_ card: Card) {
        
    }
    
    init(numberOfPairsOfCards: Int, createContent: (Int) -> CardContent) {
        for pairIndex in 0..<numberOfPairsOfCards {
            cards.append(Card(content: createContent(pairIndex)))
        }
    }
    
    struct Card {
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
    }
}
