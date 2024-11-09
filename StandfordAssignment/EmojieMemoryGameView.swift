//
//  EmojieMemoryGameView.swift
//  Standford ass2
//
//  Created by Ali on 11/4/24.
//

import SwiftUI

struct EmojieMemoryGameView: View {
    @ObservedObject var viewModel: EmojieMemoryGame
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
                .padding()
            }
            deckBody
        }
        .padding()
    }
    
    @Namespace private var dealingNamespace
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojieMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUnDealt(_ card: EmojieMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojieMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = viewModel.cards.index(matching: card) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(viewModel.cards.count))
        }
        return Animation.easeInOut(duration: 1).delay(delay)
    }
    
    private func zIndex(of card: EmojieMemoryGame.Card) -> Double {
        -Double(viewModel.cards.index(matching: card) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: viewModel.cards, aspectRatio: 2/3) { card in
            if isUnDealt(card) || (card.isMatched && !card.isFacedUp)  {
                Color.clear
            } else {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale).animation(.easeInOut(duration: 3)))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            viewModel.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(viewModel.cards.filter(isUnDealt)) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealWidth, height: CardConstants.undealHeight)
        .onTapGesture {
            for card in viewModel.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
        .foregroundColor(CardConstants.color)
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                viewModel.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            dealt = []
            viewModel.restart()
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealHeight: CGFloat = 90
        static let undealWidth = undealHeight * aspectRatio
    }
}

struct CardView: View {
    private let card: EmojieMemoryGame.Card
    
    init(_ card: EmojieMemoryGame.Card) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Pie(startAngle: (Angle(degrees: 0-90)), endAngle: (Angle(degrees: 110-90)))
                    .padding(5).opacity(0.5)
                    .overlay {
                        Text(card.content).font(font(in: geometry.size))
                    }
            }.cardify(isFacedUp: card.isFacedUp)
        }
    }
    
    private func font(in size : CGSize) -> Font {
        Font.system(size: min(size.width, size.height ) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.65
    }
}

#Preview {
    let viewModel = EmojieMemoryGame()
    return EmojieMemoryGameView(viewModel: viewModel)
}
