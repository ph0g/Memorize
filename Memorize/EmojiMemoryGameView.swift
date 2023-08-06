//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Pierre-Hugues Oger on 06/05/2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                VStack {
                    title
                    Group {
                        if themeButtonClicked {
                            themeBody
                        } else {
                            gameBody
                        }
                    }
                    HStack {
                        restart
                        Spacer()
                        shuffle
                    }
                    .padding(.horizontal)
                    
                }
                deckBody
            }
            .padding()
            HStack {
                ForEach(game.themes) { theme in
                    ThemeButton(theme) {
                        game.setTheme(theme)
                        themeButtonClicked = true
                    }
                }
            }
        }
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return .easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var title: some View {
        Text("Memorize!")
            .font(.title)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards,  aspectRatio: CardConstants.aspectRatio) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(CardConstants.color)
    }
    
    var themeBody: some View {
        let cards = game.cards.filter { $0.id % 2 == 0}
        return AspectVGrid(items: cards, aspectRatio: CardConstants.aspectRatio) { card in
            GeometryReader { geometry in
                Text(card.content)
                    .font(Font.system(size: CardView.DrawingConstants.fontSize))
                    .scaleEffect(CardView.scale(thatFits: geometry.size))
                    .cardify(isFaceUp: true)
            }
            .padding(4)
        }
    }
    
    @State private var themeButtonClicked = false
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            // *deal* cards
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
        
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
 
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
    
    

    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: CGFloat = 0.5
        static let totalDealDuration: CGFloat = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    private let card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining = 0.0
    
    init(_ card: EmojiMemoryGame.Card) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                        
                    }
                }
                .padding(DrawingConstants.circlePadding)
                .opacity(DrawingConstants.circleOpacity)
                Text(card.content)
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(CardView.scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        })
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    static func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / DrawingConstants.fontSize * DrawingConstants.fontScale
    }
    
    struct DrawingConstants {
        static let fontScale: CGFloat = 0.65
        static let fontSize: CGFloat = 32
        static let circlePadding: CGFloat = 5
        static let circleOpacity: CGFloat = 0.5
    }
}

struct ThemeButton: View {
    private let theme: EmojiMemoryGame.Theme
    private let action: () -> Void
    
    init(_ theme: EmojiMemoryGame.Theme, action: @escaping () -> Void) {
        self.theme = theme
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: theme.systemImage)
                    .font(.largeTitle)
                Label(theme.name, systemImage: theme.systemImage)
                    .labelStyle(.titleOnly)
                    .font(.caption)
                    .frame(maxWidth: .infinity) // spread the buttons evenly across the container width
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)

        return Group {
            EmojiMemoryGameView(game: game)
                .preferredColorScheme(.dark)
            EmojiMemoryGameView(game: game)
                .preferredColorScheme(.light)
        }
    }
}
