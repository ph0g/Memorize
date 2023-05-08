//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Pierre-Hugues Oger on 06/05/2023.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
