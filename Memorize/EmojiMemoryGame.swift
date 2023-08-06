//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Pierre-Hugues Oger on 07/05/2023.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static func createMemoryGame(using theme: Theme) -> MemoryGame<String> {
        let emojis =  theme.emojis.map({ String($0) }).shuffled()
        
        return MemoryGame<String>(numberOfPairsOfCards: Theme.Constants.minimumEmojisCount) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model: MemoryGame<String>
    
    @Published private(set) var themes: [Theme]
    
    @Published private(set) var currentTheme: Theme
    
    init() {
        Theme.addTheme(named: "Vehicles", systemImage: "car", emojis: "🚗🚕🚙🚎🏎️🚓🚑🚒🚐🛻🚚🚛🚜🛴🚲🏍️🛺🚌🚁🛵🚂🚀🛸⛵️")
        Theme.addTheme(named: "Faces", systemImage: "face.smiling", emojis: "😀😍🤪😭🥵😱🥸😷🤮🤑😈🤡👻💀")
        Theme.addTheme(named: "Sports", systemImage: "figure.disc.sports", emojis: "⛷️🏂🪂🤼‍♀️🤸‍♀️⛹️‍♀️🤺🤾‍♀️🏌️‍♀️🏇🏄‍♀️🏊‍♀️🤽‍♀️🧗‍♀️🚴‍♀️")
        Theme.addTheme(named: "Flora", emojis: "🌵🎄🌲🌳🌴🌱🌿☘️🪴🍃🍂🍁🍄🌷🪻🌸🌼🌻")
        themes = Theme.list
        
        let _currentTheme = Theme.named("Flora")!
        currentTheme = _currentTheme
        model = EmojiMemoryGame.createMemoryGame(using: _currentTheme)
    }
    
    var cards: [Card] {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame(using: currentTheme)
    }
    
    func setTheme(_ theme: Theme) {
        currentTheme = theme
        restart()
    }
    
    struct Theme: Identifiable {
        static private(set) var list = [Theme]()
        
        let name: String
        let systemImage: String
        let emojis: String
        
        var id: String {
            name
        }
        
        fileprivate init?(name: String, systemImage: String = Constants.defaultSystemImage, emojis: String) {
            guard emojis.count >= Constants.minimumEmojisCount, Theme.list.firstIndex(where: { $0.name == name }) == nil else { return nil }
            self.name = name
            self.systemImage = systemImage
            self.emojis = emojis
            Theme.list.append(self)
        }
        
        @discardableResult
        static func addTheme(named name: String, systemImage: String, emojis: String) -> Theme? {
            Theme(name: name, systemImage: systemImage, emojis: emojis)
        }
        
        @discardableResult
        static func addTheme(named name: String, emojis: String) -> Theme? {
            Theme(name: name, emojis: emojis)
        }
        
        static func named(_ name: String) -> Theme? {
            list.first { $0.name == name }
        }
        
        struct Constants {
            static let minimumEmojisCount = 8
            static let defaultSystemImage = "questionmark.circle"
        }
    }
    
}





