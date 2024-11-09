//
//  StandfordAssignmentApp.swift
//  Standford assignment
//
//  Created by Ali on 11/4/24.
//

import SwiftUI

@main
struct StandfordAssignmentApp: App {
    private let viewModel = EmojieMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojieMemoryGameView(viewModel: viewModel)
        }
    }
}
