//
//  EmojiMemomryGame.swift
//  Memorize
//
//  Created by Pierre-Hugues Oger on 07/05/2023.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<Character> {
        let emojis = Array(theme.emojis).shuffled()
        return MemoryGame<Character>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { pairIndex in emojis[pairIndex] }
    }
    
    @Published private var theme: Theme!
    @Published private var model: MemoryGame<Character>!

    func startNewGame() {
        theme = Theme.list.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)

    }
    
    init() {
        Theme.createThemes()
        startNewGame()
    }
    
    var cards: [MemoryGame<Character>.Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<Character>.Card) {
        model.choose(card)
    }
    
    struct Constant {
        static let defaultColor = Color.green
    }
    
    var themeColor: Color {
        guard !theme.colors.isEmpty else { return EmojiMemoryGame.Constant.defaultColor }
        return EmojiMemoryGame.colorMap[theme.colors[0]] ?? EmojiMemoryGame.Constant.defaultColor
    }
    
    var themeGradient: Gradient? {
        guard theme.colors.count > 1 else { return nil }
        return Gradient(colors: theme.colors.map({ EmojiMemoryGame.colorMap[$0] ?? EmojiMemoryGame.Constant.defaultColor }))
    }
    
    var themeName: String {
        theme.name
    }
    
    private static let colorMap: [Theme.Color: Color] = [
        .yellow: Color.yellow,
        .blue: Color.blue,
        .brown: Color.brown,
        .gray: Color.gray,
        .orange: Color.orange,
        .purple: Color.purple,
        .green: Color.green,
        .mint: Color.mint,
        .teal: Color.teal,
        .cyan: Color.cyan,
        .indigo: Color.indigo,
        .pink: Color.pink
    ]
}




