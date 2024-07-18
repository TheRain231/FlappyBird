//
//  GameScene.swift
//  FlappyBird
//
//  Created by Андрей Степанов on 08.06.2024.
//

import Foundation
import SwiftUI
import GameKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
    private let lightTexture = SKTexture(imageNamed: "background-day")
    private let darkTexture = SKTexture(imageNamed: "background-night")
    private let background = SKSpriteNode(imageNamed: "background-day")
    private let background2 = SKSpriteNode(imageNamed: "background-day")
    let base = SKSpriteNode(imageNamed: "base")
    private let base2 = SKSpriteNode(imageNamed: "base")
    
    private var player = SKSpriteNode(imageNamed: "yellowbird-midflap")
    private var playerAtlas = SKTextureAtlas(named: "yellowbird")
    private var pipes: [Pipe] = []
    var scheme: ColorScheme = .light
    
    var isMenu = true
    private var maxRotationAngle = 1.0
    let baseSpeed = 5.0
    var score = 0 {
        didSet {
            NotificationCenter.default.post(name: .scoreChanged, object: nil)
        }
    }
    private var isDead = false
    
    private var playerIdleTextures: [SKTexture] {
        return [
            playerAtlas.textureNamed("yellowbird-midflap"),
            playerAtlas.textureNamed("yellowbird-upflap"),
            playerAtlas.textureNamed("yellowbird-midflap"),
            playerAtlas.textureNamed("yellowbird-downflap")
        ]
    }
    
    private var audioPlayer: AVAudioPlayer?
    private var nextAudioFileName: String?

    private let soundOfPoint = SKAction.playSoundFileNamed("sfx_point", waitForCompletion: false)
    private let soundOfSwoosh = SKAction.playSoundFileNamed("sfx_swooshing", waitForCompletion: false)
    private let soundOfWing = SKAction.playSoundFileNamed("sfx_wing", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        scene?.size = CGSize(width: 1179, height: 2556)
        self.setBackground()
        self.setPlayer()
        self.setPhysics()
        self.setPipe()
        
        self.startIdleAnimation()
        self.startBackgroundAnimation()
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if ((contact.bodyA.categoryBitMask == 0x1 << 1 && contact.bodyB.categoryBitMask == 0x1 << 0 || contact.bodyB.categoryBitMask == 0x1 << 1 && contact.bodyA.categoryBitMask == 0x1 << 0 ) && !isDead){
            let stop = SKAction.run { [weak self] in
                guard let pipes = self?.pipes else {
                    return
                }
                for pipe in pipes {
                    pipe.stop()
                }
                self?.background.removeAllActions()
                self?.background2.removeAllActions()
                self?.base.removeAllActions()
                self?.base2.removeAllActions()
                
                guard let physicsBody = self?.player.physicsBody else { return }
                    
                // Устанавливаем маски коллизий и контактов в 0
                physicsBody.categoryBitMask = 0
                physicsBody.collisionBitMask = 0
                physicsBody.contactTestBitMask = 0
                self?.applyImpulseToPlayer(withSound: false)
                self?.playSound(fileName: "sfx_hit.wav", nextFileName: "sfx_die.wav", volume: 1)
            }
            let wait = SKAction.wait(forDuration: 3)
            let restart = SKAction.run { [weak self] in
                self?.restartGame()
            }
            run(SKAction.sequence([stop, wait, restart]))
        }
        if (contact.bodyA.categoryBitMask == 0x1 << 2 && contact.bodyB.categoryBitMask == 0x1 << 0 ||
            contact.bodyB.categoryBitMask == 0x1 << 2 && contact.bodyA.categoryBitMask == 0x1 << 0 ) {
            score += 1
            run(soundOfPoint)
            if (contact.bodyA.categoryBitMask == 0x1 << 2){
                contact.bodyA.node?.physicsBody?.categoryBitMask = 0x1 << 3
            } else {
                contact.bodyB.node?.physicsBody?.categoryBitMask = 0x1 << 3
            }
        }
    }
    
    // Функция для перезапуска игры
    func restartGame() {
        if let view = self.view {
            let newScene = GameScene(size: self.size)
            newScene.scaleMode = self.scaleMode
            let transition = SKTransition.crossFade(withDuration: 1.0)
            view.presentScene(newScene, transition: transition)
            score = 0
            newScene.setTheme(colorScheme: scheme)
            ContentView.scene = newScene
        }
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
        base.zPosition = 5
        addChild(base)
        
        base2.position = CGPoint(x: size.width / 2 + base.size.width, y: 0)
        base2.setScale(scale)
        base2.zPosition = 5
        addChild(base2)
    }
    
    private func setPlayer(){
        player.position = CGPoint(x: size.width / 5, y: size.height / 2)
        player.setScale(size.width / 350)
        player.zPosition = 5
        
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = 0x1 << 0
        player.physicsBody?.contactTestBitMask = 0x1 << 1 | 0x1 << 2
        player.physicsBody?.collisionBitMask = 0x1 << 1
        
        addChild(player)
    }
    
    private func setPipe(){
        let offset = background.size.width / 3
        pipes.append(Pipe(gameScene: self, posx: 0))
        pipes.append(Pipe(gameScene: self, posx: offset))
        pipes.append(Pipe(gameScene: self, posx: offset * 2))
    }
    
    func setTheme(colorScheme: ColorScheme){
        scheme = colorScheme
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
    
    func applyImpulseToPlayer(withSound: Bool = true) {
        let impulse = CGVector(dx: 0, dy: 1200)
        player.physicsBody?.velocity = impulse
        if (withSound){
            player.run(soundOfWing)
        }
    }
    
    private func rotatePlayer(){
        guard let physicsBody = player.physicsBody else { return }
        
        let velocityY = physicsBody.velocity.dy
        let targetRotationAngle = max(-maxRotationAngle, min(maxRotationAngle, velocityY / 1000 * maxRotationAngle))
        
        // Линейная интерполяция для плавного поворота
        let lerpFactor: CGFloat = 0.1
        player.zRotation = player.zRotation * (1 - lerpFactor) + targetRotationAngle * lerpFactor
        player.position.x = size.width / 5
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
        
        let moveLeftForBase = SKAction.moveBy(x: -base.size.width, y: 0, duration: baseSpeed)
        let resetPositionForBase = SKAction.moveBy(x: base.size.width, y: 0, duration: 0)
        let moveSequenceForBase = SKAction.sequence([moveLeftForBase, resetPositionForBase])
        let moveForeverForBase = SKAction.repeatForever(moveSequenceForBase)
        
        background.run(moveForever)
        background2.run(moveForever)
        base.run(moveForeverForBase)
        base2.run(moveForeverForBase)
    }
    
    private func playSound(fileName: String, nextFileName: String?, volume: Float) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Could not find file: \(fileName)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = volume
            audioPlayer?.delegate = self
            nextAudioFileName = nextFileName
            audioPlayer?.play()
        } catch {
            print("Could not create audio player: \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let nextFileName = nextAudioFileName {
            playSound(fileName: nextFileName, nextFileName: nil, volume: player.volume)
        }
    }
}

extension Notification.Name {
    static let scoreChanged = Notification.Name("scoreChanged")
}
