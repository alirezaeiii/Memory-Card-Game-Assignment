//
//  CardGame.swift
//  Standford assignment
//
//  Created by Ali on 11/4/24.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFacedUp }).oneAndOnly }
        set { cards.indices.forEach({ cards[$0].isFacedUp = ($0 == newValue) })}
    }
    
    mutating func choose(_ card: Card) {
        if let choosenIndex = cards.index(matching: card),
           !cards[choosenIndex].isFacedUp,
           !cards[choosenIndex].isMatched {
            if let potentialCardIndex = indexOfOneAndOnlyFaceUpCard {
                if cards[choosenIndex].content == cards[potentialCardIndex].content {
                    cards[choosenIndex].isMatched = true
                    cards[potentialCardIndex].isMatched = true
                }
                cards[choosenIndex].isFacedUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = choosenIndex
            }
        
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    init(numberOfPairsOfCard: Int, createCardContent: (Int)-> CardContent) {
        cards = []
        for cardIndex in 0...numberOfPairsOfCard {
            let content = createCardContent(cardIndex)
            cards.append(Card(content: content, id: cardIndex*2))
            cards.append(Card(content: content, id: cardIndex*2+1))
        }
        shuffle()
    }
    
    struct Card: Identifiable {
        var isFacedUp = false
        var isMatched = false
        let content: CardContent
        let id: Int
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            first
        } else {
            nil
        }
    }
}

extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
}
