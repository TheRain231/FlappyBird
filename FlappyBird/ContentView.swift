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
    @State private var score = 0
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
            VStack{
                HStack{
                    Text(String(score))
                        .bold()
                    #if DEBUG
                    Spacer()
                    Button {
                        ContentView.scene.restartGame()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }.buttonStyle(.bordered)
                    #endif
                }
                .padding(20)
                Spacer()
            }
            
            
        }.onChange(of: colorScheme) {
            ContentView.scene.setTheme(colorScheme: colorScheme)
        }
        .onReceive(NotificationCenter.default.publisher(for: .scoreChanged)) { _ in
            self.score = ContentView.scene.score
        }
    }
}

#Preview {
    ContentView()
}
