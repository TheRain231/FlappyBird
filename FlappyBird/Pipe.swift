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
    
    let scene: GameScene
    
    let id = UUID()
    let upperSprite = SKSpriteNode(imageNamed: "pipe")
    let lowerSprite = SKSpriteNode(imageNamed: "pipe")
    var offsite = CGFloat.random(in: -700...700)
    var hole = CGFloat.random(in: -50...0)
    var posX: CGFloat = 0
    
    init(gameScene: GameScene, posx: CGFloat){
        scene = gameScene
        posX = posx
        
        upperSprite.zPosition = 4
        upperSprite.zRotation = .pi
        upperSprite.position = CGPoint(x: scene.size.width + upperSprite.size.width * 2 + posX, y: scene.size.height - offsite - hole)
        upperSprite.setScale(scene.size.height / 800)
        
        lowerSprite.zPosition = 4
        lowerSprite.position = CGPoint(x: scene.size.width + lowerSprite.size.width * 2 + posX, y: -offsite + hole)
        lowerSprite.setScale(scene.size.height / 800)
        
        scene.addChild(lowerSprite)
        scene.addChild(upperSprite)
        
        startPipesAnimation()
    }
    
    private func randomise(){
        offsite = CGFloat.random(in: -700...700)
        hole = CGFloat.random(in: -50...0)
        
        upperSprite.position.y = scene.size.height - offsite - hole
        lowerSprite.position.y = -offsite + hole
    }
    
    private func startPipesAnimation(){
        let moveToBorder = SKAction.moveTo(x: scene.size.width + upperSprite.size.width * 2,
                                         duration: (scene.baseSpeed * posX / 1440))
    
        let moveLeft = SKAction.moveBy(x: -scene.base.size.width, y: 0, duration: scene.baseSpeed)
        let resetPosition = SKAction.moveTo(x: scene.size.width + lowerSprite.size.width * 2, duration: 0)
        let random = SKAction.run {
            self.randomise()
        }
        let moveSequence = SKAction.sequence([moveLeft, resetPosition, random])
        let moveForever = SKAction.repeatForever(moveSequence)
        let sequence = SKAction.sequence([moveToBorder, moveForever])
        upperSprite.run(sequence)
        lowerSprite.run(sequence)
    }
}
