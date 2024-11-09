//
//  Cardify.swift
//  Standford assignment
//
//  Created by Ali on 11/8/24.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    init(isFacedUp: Bool) {
        rotation = isFacedUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill()
            }
            content.opacity(rotation < 90 ? 1 : 0)
        }.rotation3DEffect(Angle.degrees(rotation),axis: (x: 0, y: 1, z: 0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFacedUp: Bool) -> some View {
        return self.modifier(Cardify(isFacedUp: isFacedUp))
    }
}
