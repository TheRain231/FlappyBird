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
    let holeMin = -45.0
    let holeMax = -25.0
    var hole: CGFloat
    var posX: CGFloat = 0
    let holeSprite: SKSpriteNode
    static var lastY: CGFloat = 0.0
    
    init(gameScene: GameScene, posx: CGFloat){
        scene = gameScene
        posX = posx
        hole = CGFloat.random(in: holeMin...holeMax)
        holeSprite = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: scene.size.height))
        
        upperSprite.zPosition = 4
        upperSprite.zRotation = .pi
        upperSprite.position = CGPoint(x: scene.size.width + upperSprite.size.width * 2 + posX, y: scene.size.height - offsite - hole)
        upperSprite.setScale(scene.size.height / 800)
        
        upperSprite.physicsBody = SKPhysicsBody(texture: upperSprite.texture!, size: upperSprite.size)
        upperSprite.physicsBody?.isDynamic = false
        upperSprite.physicsBody?.allowsRotation = false
        
        upperSprite.physicsBody?.categoryBitMask = 0x1 << 1
        upperSprite.physicsBody?.contactTestBitMask = 0x1 << 0
        upperSprite.physicsBody?.collisionBitMask = 0x1 << 0
        
        lowerSprite.zPosition = 4
        lowerSprite.position = CGPoint(x: scene.size.width + lowerSprite.size.width * 2 + posX, y: -offsite + hole)
        lowerSprite.setScale(scene.size.height / 800)
        
        lowerSprite.physicsBody = SKPhysicsBody(texture: lowerSprite.texture!, size: lowerSprite.size)
        lowerSprite.physicsBody?.isDynamic = false
        lowerSprite.physicsBody?.allowsRotation = false
        
        lowerSprite.physicsBody?.categoryBitMask = 0x1 << 1
        lowerSprite.physicsBody?.contactTestBitMask = 0x1 << 0
        lowerSprite.physicsBody?.collisionBitMask = 0x1 << 0
        
        holeSprite.zPosition = 4
        holeSprite.position = CGPoint(x: scene.size.width + lowerSprite.size.width * 2 + posX, y: 0)
        holeSprite.setScale(scene.size.height / 800)
        
        holeSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: scene.size.height * 2))
        holeSprite.physicsBody?.isDynamic = false
        holeSprite.physicsBody?.allowsRotation = false
        
        holeSprite.physicsBody?.categoryBitMask = 0x1 << 2
        holeSprite.physicsBody?.contactTestBitMask = 0x1 << 0
        randomise()
        
        scene.addChild(lowerSprite)
        scene.addChild(upperSprite)
        scene.addChild(holeSprite)
        
        startPipesAnimation()
    }
    
    private func randomise(){
        offsite = CGFloat.random(in: -700...700)
        while (abs(offsite - Pipe.lastY) >= 700){
            offsite = CGFloat.random(in: -700...700)
        }
        Pipe.lastY = offsite
        hole = CGFloat.random(in: holeMin...holeMax)

        upperSprite.position.y = scene.size.height - offsite - hole
        lowerSprite.position.y = -offsite + hole
        
        holeSprite.physicsBody?.categoryBitMask = 0x1 << 2
    }
    
    private func startPipesAnimation(){
        let moveToBorder = SKAction.moveTo(x: scene.size.width + upperSprite.size.width * 2,
                                         duration: (scene.baseSpeed * posX / 1440))
        let waitALittle = SKAction.moveBy(x: 0, y: 0, duration: scene.baseSpeed / 20)
    
        let moveLeft = SKAction.moveBy(x: -scene.base.size.width, y: 0, duration: scene.baseSpeed)
        let resetPosition = SKAction.moveTo(x: scene.size.width + lowerSprite.size.width * 2, duration: 0)
        let random = SKAction.run {
            self.randomise()
        }
        let moveSequence = SKAction.sequence([moveLeft, resetPosition, random])
        let moveForever = SKAction.repeatForever(moveSequence)
        let sequence = SKAction.sequence([moveToBorder, moveForever])
        let sequence2 = SKAction.sequence([moveToBorder, waitALittle, moveForever])
        upperSprite.run(sequence)
        lowerSprite.run(sequence)
        holeSprite.run(sequence2)
    }
    
    func stop(){
        upperSprite.removeAllActions()
        lowerSprite.removeAllActions()
        holeSprite.removeAllActions()
    }
}
