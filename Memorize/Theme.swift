//
//  Theme.swift
//  Memorize
//
//  Created by Pierre-Hugues Oger on 06/08/2023.
//

import Foundation

struct Theme {
    static var list = [Theme]()
    var name: String
    var emojis: Set<Character>
    var colors: [Theme.Color]
    var numberOfPairsOfCards: Int
    
    fileprivate init(name: String, emojis: String, colors: [Theme.Color], numberOfPairsOfCards: NumberOfPairsOfCards) {
        self.name = name
        self.emojis = Set([Character](emojis))
        self.colors = colors
        switch numberOfPairsOfCards {
        case .random:
            self.numberOfPairsOfCards = Int.random(in: 1...emojis.count)
        case .fixed(let n):
            self.numberOfPairsOfCards = (1...emojis.count).contains(n) ? n : emojis.count
        }
        
    }
    
    fileprivate init(name: String, emojis: String, color: Theme.Color, numberOfPairsOfCards: NumberOfPairsOfCards) {
        self = Theme(name: name, emojis: emojis, colors: [color], numberOfPairsOfCards: numberOfPairsOfCards)
    }

    
    fileprivate init(name: String, emojis: String, colors: [Theme.Color]) {
        self = Theme(name: name, emojis: emojis, colors: colors, numberOfPairsOfCards: .fixed(emojis.count))
    }
    
    fileprivate init(name: String, emojis: String, color: Theme.Color) {
        self = Theme(name: name, emojis: emojis, colors: [color])
    }
    
    enum NumberOfPairsOfCards {
        case random
        case fixed(Int)
    }
    
    static func createThemes() {
        list.append(Theme(name: "Vehicles", emojis: "🚗🚕🚙🚎🏎️🚓🚑🚒🚐🛻🚚🚛🚜🛴🚲🏍️🛺🚌🚁🛵🚂🚀🛸⛵️", colors: [.yellow, .pink], numberOfPairsOfCards: .fixed(10)))
        list.append(Theme(name: "Faces", emojis: "🥵🥶😶‍🌫️😱🤪🙂😰🤗😈🤠🤥🤮😇🤬🥹😂🥴🤢🫠", colors: [.purple, .indigo, .teal], numberOfPairsOfCards: .fixed(8)))
        list.append(Theme(name: "Animals", emojis: "🪱🦋🐌🐍🐬🐋🐪🦧🦓🐊🦘🐄🐎🐖🐏🐓🐈🦢🦜🐠🦀", color: .blue, numberOfPairsOfCards: .random))
        list.append(Theme(name: "Vegies", emojis: "🍏🍐🍊🍋🍌🍉🍇🍓🫐🍈🍒🍆🥑🍠🫚🧄🥕🌽🌶️", color: .gray, numberOfPairsOfCards: .fixed(9)))
        list.append(Theme(name: "Halloween", emojis: "👻💀☠️👽🤖🎃🤡👺👹👿", color: .orange, numberOfPairsOfCards: .fixed(12)))
        list.append(Theme(name: "Fashion", emojis: "🧥🥼🦺👚👕👖🩲🩳👔👗👙🩱👘🥻🩴👠👡👞👢👟", color: .brown))
    }
    
    enum Color : String {
        case yellow = "yellow"
        case blue = "blue"
        case brown = "brown"
        case gray = "gray"
        case orange = "orange"
        case purple = "purple"
        case green = "green"
        case mint = "mint"
        case teal = "teal"
        case cyan = "cyan"
        case indigo = "indigo"
        case pink = "pink"
    }

}
