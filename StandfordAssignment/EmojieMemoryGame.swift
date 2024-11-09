//
//  EmojieMemoryGame.swift
//  Standford assignment
//
//  Created by Ali on 11/4/24.
//

import Foundation

class EmojieMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static let emojies = ["🚞", "🚕", "🚌", "🚒", "🦼", "🚔", "🛻",
                          "a", "b", "c", "d", "e", "f", "g"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCard: 8) { index in
            emojies[index]
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojieMemoryGame.createMemoryGame()
    }
}

