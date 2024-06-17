//
//  GameScene.swift
//  FlappyBird
//
//  Created by Андрей Степанов on 08.06.2024.
//

import Foundation
import SwiftUI
import GameKit

class GameScene: SKScene {
    private let lightTexture = SKTexture(imageNamed: "background-day")
    private let darkTexture = SKTexture(imageNamed: "background-night")
    private let background = SKSpriteNode(imageNamed: "background-day")
    private let background2 = SKSpriteNode(imageNamed: "background-day")
    private let base = SKSpriteNode(imageNamed: "base")
    private let base2 = SKSpriteNode(imageNamed: "base")
    
    private var player = SKSpriteNode(imageNamed: "yellowbird-midflap")
    private var playerAtlas = SKTextureAtlas(named: "yellowbird")
    
    var score = 0
    var isMenu = true
    private var maxRotationAngle = 1.0
    
    private var playerIdleTextures: [SKTexture] {
        return [
            playerAtlas.textureNamed("yellowbird-midflap"),
            playerAtlas.textureNamed("yellowbird-upflap"),
            playerAtlas.textureNamed("yellowbird-midflap"),
            playerAtlas.textureNamed("yellowbird-downflap")
        ]
    }
    
    override func didMove(to view: SKView) {
        scene?.size = CGSize(width: 1179, height: 2556)
        self.setBackground()
        self.setPlayer()
        self.setPhysics()
        
        self.startIdleAnimation()
        self.startBackgroundAnimation()
    }
    
    override func update(_ currentTime: TimeInterval) {
        rotatePlayer()
    }
    
    private func setBackground(){
        let scale = size.height / 512

        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.setScale(scale)
        background.zPosition = 1
        addChild(background)
        
        background2.position = CGPoint(x: size.width / 2 + background.size.width - 6, y: size.height / 2)
        background2.setScale(scale)
        background2.zPosition = 1
        addChild(background2)
        
        base.position = CGPoint(x: size.width / 2, y: 0)
        base.setScale(scale)
        base.zPosition = 2
        addChild(base)
        
        base2.position = CGPoint(x: size.width / 2 + base.size.width, y: 0)
        base2.setScale(scale)
        base2.zPosition = 2
        addChild(base2)
    }
    
    private func setPlayer(){
        player.position = CGPoint(x: size.width / 5, y: size.height / 2)
        player.setScale(size.width / 350)
        player.zPosition = 2
        
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.allowsRotation = false
        
        addChild(player)
    }
    
    func setTheme(colorScheme: ColorScheme){
        switch colorScheme {
        case .light:
            background.texture = lightTexture
            background2.texture = lightTexture
        case .dark:
            background.texture = darkTexture
            background2.texture = darkTexture
        @unknown default:
            break
        }
    }
    
    func applyImpulseToPlayer() {
        let impulse = CGVector(dx: 0, dy: 1200)
        player.physicsBody?.velocity = impulse
    }
    
    private func rotatePlayer(){
        guard let physicsBody = player.physicsBody else { return }
            
            let velocityY = physicsBody.velocity.dy
            let targetRotationAngle = max(-maxRotationAngle, min(maxRotationAngle, velocityY / 1000 * maxRotationAngle))
            
            // Линейная интерполяция для плавного поворота
            let lerpFactor: CGFloat = 0.1
            player.zRotation = player.zRotation * (1 - lerpFactor) + targetRotationAngle * lerpFactor
    }
    
    private func setPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -18)
        self.setPhysicsBoundaries()
    }
    
    private func setPhysicsBoundaries() {
        // Создаем физическое тело для границ сцены
        let borderBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: base.size.height/2, width: self.frame.width, height: self.frame.height - base.size.height/2))
        borderBody.friction = 0 // устанавливаем трение границы
        self.physicsBody = borderBody
    }
    
    private func startIdleAnimation(){
        let idleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.1)
        
        player.run(SKAction.repeatForever(idleAnimation), withKey: "playerIdleAnimation")
    }
    
    private func startBackgroundAnimation() {
        let backgroundSpeed = 20.0
        let moveLeft = SKAction.moveBy(x: -background.size.width, y: 0, duration: backgroundSpeed)
        let resetPosition = SKAction.moveBy(x: background.size.width, y: 0, duration: 0)
        let moveSequence = SKAction.sequence([moveLeft, resetPosition])
        let moveForever = SKAction.repeatForever(moveSequence)
        
        let baseSpeed = 5.0
        let moveLeftForBase = SKAction.moveBy(x: -base.size.width, y: 0, duration: baseSpeed)
        let resetPositionForBase = SKAction.moveBy(x: base.size.width, y: 0, duration: 0)
        let moveSequenceForBase = SKAction.sequence([moveLeftForBase, resetPositionForBase])
        let moveForeverForBase = SKAction.repeatForever(moveSequenceForBase)
        
        background.run(moveForever)
        background2.run(moveForever)
        base.run(moveForeverForBase)
        base2.run(moveForeverForBase)
    }
}
