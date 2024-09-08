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
    @State private var isDead = false
    static var scene = GameScene(hasBegan: false)
    
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
                StrokeText(text: String(score), width: 2, color: .black)
                    .foregroundStyle(.white)
                    .font(.custom("04b19", size: 40))
                    .offset(y: 30)
                Spacer()
            }
            if (isDead){
                MenuView(isStart: false, score: self.score)
            }
            
        }.onAppear{
            do {
                let audioSession = AVAudioSession.sharedInstance()
                
                try audioSession.setCategory(.ambient, options: [.mixWithOthers])
                
                try audioSession.setActive(true)
            } catch {
                print("Ошибка настройки аудиосессии: \(error)")
            }
        }
        .task {
            self.launchScreenState.dismiss()
        }
        .onChange(of: colorScheme) {
            ContentView.scene.setTheme(colorScheme: colorScheme)
        }
        .onReceive(NotificationCenter.default.publisher(for: .scoreChanged)) { _ in
            self.score = ContentView.scene.score
        }
        .onReceive(NotificationCenter.default.publisher(for: .gameOver), perform: { _ in
            if (!isDead){
                print("death")
            }
            withAnimation(.interactiveSpring) {
                isDead = true
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: .restartButton), perform: { _ in
            ContentView.scene.restartGame()
            isDead = false
        })
        .onReceive(NotificationCenter.default.publisher(for: .startButton), perform: { _ in
            ContentView.scene.begin()
        })
    }
}


struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LaunchScreenStateManager())
}
