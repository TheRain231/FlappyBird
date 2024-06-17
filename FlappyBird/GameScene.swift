//
//  GameScene.swift
//  FlappyBird
//
//  Created by Андрей Степанов on 08.06.2024.
//

import Foundation
import GameKit

class GameScene: SKScene{
    
    private let background = SKSpriteNode(imageNamed: "background-day")
    private let background2 = SKSpriteNode(imageNamed: "background-day")
    
    private var player = SKSpriteNode(imageNamed: "yellowbird-midflap")
    private var playerAtlas = SKTextureAtlas(named: "yellowbird")
    
    var score = 0
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
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0 // устанавливаем трение границы
        self.physicsBody = borderBody
    }
    
    private func startIdleAnimation(){
        let idleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.1)
        
        player.run(SKAction.repeatForever(idleAnimation), withKey: "playerIdleAnimation")
    }
    
    private func startBackgroundAnimation() {
        let moveLeft = SKAction.moveBy(x: -background.size.width, y: 0, duration: 5)
        let resetPosition = SKAction.moveBy(x: background.size.width, y: 0, duration: 0)
        let moveSequence = SKAction.sequence([moveLeft, resetPosition])
        let moveForever = SKAction.repeatForever(moveSequence)
        
        background.run(moveForever)
        background2.run(moveForever)
    }
}
