//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Pierre-Hugues Oger on 06/05/2023.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
