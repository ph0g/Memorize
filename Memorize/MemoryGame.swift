//
//  MemoryGame.swift
//  Memorize
//
//  Created by Pierre-Hugues Oger on 07/05/2023.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards = [Card]()
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    private(set) var score = 0
    
    private var timeLastCardWasChosen: Date?
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            let date = Date.now
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2 * max(10 - Int(date.timeIntervalSince(timeLastCardWasChosen!)), 1)
                } else {
                    if cards[potentialMatchIndex].hasAlreadyBeenSeen || cards[chosenIndex].hasAlreadyBeenSeen {
                        score -= max(1, min(Int(date.timeIntervalSince(timeLastCardWasChosen!)), 10))
                    }
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    if cards[index].isFaceUp {
                        cards[index].hasAlreadyBeenSeen = true
                        cards[index].isFaceUp = false
                    }
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                timeLastCardWasChosen = date
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
        print("\(cards)")
    }
    
    init(numberOfPairsOfCards: Int, createContent: (Int) -> CardContent) {
        for pairIndex in 0..<numberOfPairsOfCards {
            cards.append(Card(content: createContent(pairIndex), id: pairIndex*2))
            cards.append(Card(content: createContent(pairIndex), id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var hasAlreadyBeenSeen = false
        var content: CardContent
        var id: Int
    }
}
