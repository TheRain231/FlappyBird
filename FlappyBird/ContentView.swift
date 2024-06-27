//
//  ContentView.swift
//  FlappyBird
//
//  Created by Андрей Степанов on 08.06.2024.
//

import SwiftUI
import SpriteKit
import GameKit

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    static var scene = GameScene()
    
    var body: some View {
        ZStack{
            SpriteView(scene: ContentView.scene)
                .ignoresSafeArea()
                .onAppear(perform: {
                    ContentView.scene.setTheme(colorScheme: colorScheme)
                })
                .onTapGesture(perform: {
                    ContentView.scene.applyImpulseToPlayer()
                })
        }.onChange(of: colorScheme) {
            ContentView.scene.setTheme(colorScheme: colorScheme)
        }
    }
}

#Preview {
    ContentView()
}
