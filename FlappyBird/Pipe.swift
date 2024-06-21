//
//  Pipe.swift
//  FlappyBird
//
//  Created by Андрей Степанов on 17.06.2024.
//

import Foundation
import GameKit


class Pipe: Equatable, Identifiable{
    static func == (lhs: Pipe, rhs: Pipe) -> Bool {
        lhs.id == rhs.id
    }
    
    static var pipes: [Pipe] = []
    let scene: GameScene
    
    let id = UUID()
    let upperSprite = SKSpriteNode(imageNamed: "pipe")
    let lowerSprite = SKSpriteNode(imageNamed: "pipe")
    let offsite = 0.0
    let hole = 0.0
    
    init(gameScene: GameScene){
        scene = gameScene
        
        upperSprite.zPosition = 4
        upperSprite.zRotation = .pi
        upperSprite.position = CGPoint(x: scene.size.width + upperSprite.size.width * 2, y: scene.size.height - offsite - hole)
        upperSprite.setScale(scene.size.height / 800)
        
        lowerSprite.zPosition = 4
        lowerSprite.position = CGPoint(x: scene.size.width + lowerSprite.size.width * 2, y: -offsite + hole)
        lowerSprite.setScale(scene.size.height / 800)
        
        scene.addChild(lowerSprite)
        scene.addChild(upperSprite)
        
        startPipesAnimation()
    }
    
    func startPipesAnimation(){
        let moveLeft = SKAction.moveBy(x: -scene.base.size.width, y: 0, duration: scene.baseSpeed)
            let die = SKAction.run{
                if let index = Pipe.pipes.firstIndex(of: self) {
                    // Удаляем узел из массива
                    Pipe.pipes.remove(at: index)
                    
                    // Создаем новый узел
                    Pipe.pipes.append(Pipe(gameScene: self.scene))
                }
            }
            let sequence = SKAction.sequence([moveLeft, die])
            upperSprite.run(sequence)
            lowerSprite.run(sequence)
    }
}
