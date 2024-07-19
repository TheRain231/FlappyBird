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
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager
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
                Text(String(score))
                    .foregroundStyle(.white)
                    .font(.custom("04b19", size: 40))
                    .offset(y: 30)
                Spacer()
            }
            
            
        }.task {
            self.launchScreenState.dismiss()
        }
        .onChange(of: colorScheme) {
            ContentView.scene.setTheme(colorScheme: colorScheme)
        }
        .onReceive(NotificationCenter.default.publisher(for: .scoreChanged)) { _ in
            self.score = ContentView.scene.score
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LaunchScreenStateManager())
}
