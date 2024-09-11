//
//  MenuView.swift
//  FlappyBird
//
//  Created by Андрей Степанов on 10.08.2024.
//

import Foundation
import SwiftUI


struct MenuView: View {
    let isStart: Bool
    let score: Int
    let menuBorder: CGFloat = 10
    let screenHeight = UIScreen.main.bounds.height / 3.5
    let secondaryColor = Color.init(cgColor: CGColor(red: 0.6, green: 0.6, blue: 0.25, alpha: 1))
    let primaryColor = Color.init(cgColor: CGColor(red: 0.8, green: 0.8, blue: 0.45, alpha: 1))
    let cornerRadius = 10.0
    @AppStorage("maxScore", store: .init(suiteName: "group.TheRain.FlappyBird")) var maxScore = 0
    @AppStorage("isMuted") var isMuted = true
    @AppStorage("attempts", store: .init(suiteName: "group.TheRain.FlappyBird")) var attempts = 0
    
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: cornerRadius + menuBorder / 2)
                .foregroundStyle(secondaryColor)
                .padding(EdgeInsets(top: screenHeight - menuBorder, leading: 50 - menuBorder, bottom: screenHeight - menuBorder, trailing: 50 - menuBorder))
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundStyle(primaryColor)
                .padding(EdgeInsets(top: screenHeight, leading: 50, bottom: screenHeight, trailing: 50))
            
            
            VStack(alignment: .leading){
                HStack {
                    Spacer()
                    StrokeText(text: isStart ? "Flappy Bird" : "Game over", width: 2, color: .black)
                        .foregroundStyle(.white)
                        .font(.custom("04b19", size: 40))
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                    Spacer()
                }
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text(isStart ? "Attempts: \(String(attempts))" : "Score: \(String(score))")
                        .foregroundStyle(secondaryColor)
                        .font(.custom("04b19", size: 20))
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                    
                    Text("Best score: \(String(maxScore))")
                        .foregroundStyle(secondaryColor)
                        .font(.custom("04b19", size: 20))
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                } .padding(.leading, 20)
                
                
                Spacer()
                
                
                HStack {
                    Spacer()
                    Button(action: {
                        NotificationCenter.default.post(name: isStart ? .startButton : .restartButton, object: nil)
                    }, label: {
                        StrokeText(text: isStart ? "Start" : "Restart", width: 2, color: .black)
                            .foregroundStyle(.white)
                            .font(.custom("04b19", size: 20))
                    })
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .foregroundStyle(secondaryColor)
                    }
                    Button  {
                        withAnimation {
                            isMuted.toggle()
                        }
                    } label: {
                        ZStack{
                            Image(systemName: "speaker.slash.fill")
                                .foregroundStyle(.clear)
                            Image(systemName: isMuted ? "speaker.fill" : "speaker.slash.fill")
                                .contentTransition(.symbolEffect(.replace.wholeSymbol))
                                .foregroundStyle(.white)
                        }
                    }.padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .foregroundStyle(secondaryColor)
                        }
                    Spacer()
                }
                
                Spacer()
            }
            .padding(EdgeInsets(top: screenHeight, leading: 50, bottom: screenHeight, trailing: 50))
            .onAppear{
                if (score > maxScore){
                    maxScore = score
                }
            }
        }
    }
}

extension Notification.Name {
    static let restartButton = Notification.Name("restartButton")
    static let startButton = Notification.Name("startButton")
    static let muteButton = Notification.Name("muteButton")
    static let unmuteButton = Notification.Name("unmuteButton")
}


#Preview {
    MenuView(isStart: true, score: 10)
}
