//
//  ContentView.swift
//  Memorize
//
//  Created by Pierre-Hugues Oger on 06/05/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(String(format: "Score : %5d", viewModel.score))
                Spacer()
            }
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card, textOnBack: viewModel.themeName, gradient: viewModel.themeGradient)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
                .padding(.horizontal)
                .foregroundColor(viewModel.themeColor)
            }
            HStack {
                Spacer()
                Button("New Game", action: viewModel.startNewGame)
                Spacer()
            }

        }
    }
}
    
struct CardView: View {
    let card: MemoryGame<Character>.Card
    let textOnBack: String
    let gradient: Gradient?
    
    init(_ card: MemoryGame<Character>.Card, textOnBack: String, gradient: Gradient?) {
        self.card = card
        self.textOnBack = textOnBack
        self.gradient = gradient
    }
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(String(card.content)).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0.0)
            } else {
                if let gradient = gradient {
                    shape.fill(gradient)
                } else {
                    shape.fill()
                }
                Text(textOnBack)
                    .font(.caption)
                    .foregroundColor(Color.black)
                    .rotationEffect(Angle(degrees: 45))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()

        ContentView(viewModel: game)
            .preferredColorScheme(.dark)
        ContentView(viewModel: game)
            .preferredColorScheme(.light)

    }
}
