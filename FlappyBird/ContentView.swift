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
    let scene = GameScene()
    
    var body: some View {
        ZStack{
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .onAppear(perform: {
                    scene.setTheme(colorScheme: colorScheme)
                })
                .onTapGesture(perform: {
                    scene.applyImpulseToPlayer()
                })
//            Text(String(scene.score))
//                .font(.custom("flappy-font", size: 30))
//                .position(x: UIScreen.main.bounds.width / 2,
//                          y: UIScreen.main.bounds.height / 6)
        }.onChange(of: colorScheme) {
            scene.setTheme(colorScheme: colorScheme)
        }
    }
}

#Preview {
    ContentView()
}
