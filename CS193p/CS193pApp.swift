//
//  CS193pApp.swift
//  CS193p
//
//  Created by lym on 2021/4/12.
//

import SwiftUI

@main
struct CS193pApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
        }
    }
}
