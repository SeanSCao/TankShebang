//
//  Projectile.swift
//  TankShebang
//
//  Created by Sean Cao on 12/3/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import Foundation

import SpriteKit

class Projectile: SKSpriteNode {
    
    var owner:Player = Player()
    var isLaser:Bool = false
    var SFX:Bool = true
    
    func explode(scale:CGFloat, position: CGPoint){
        self.texture = SKTexture(imageNamed: "Explosion")
        self.size = self.texture!.size()
        self.zPosition = 101
        self.setScale(scale)
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.explosion
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        if (self.SFX) {
            let sound = SKAudioNode(fileNamed: "explosion.mp3")
            sound.autoplayLooped = false
            self.addChild(sound)
            self.run(SKAction.run {sound.run(SKAction.play())})
        }
    }
    
    func activateMine(){
        let rotateAction = SKAction.rotate(toAngle: 10 * .pi, duration: 1)
        let removeAction = SKAction.removeFromParent()
        let explodeAction = SKAction.run({self.explode(scale: 2, position:CGPoint(x:0,y:0))})
        let fadeAction = SKAction.fadeOut(withDuration: 0.5)
        self.run(SKAction.sequence([rotateAction, explodeAction, SKAction.wait(forDuration: 0.25), fadeAction, removeAction]))
    }
    
    func activateRocket(){
        self.removeAllActions()
        let removeAction = SKAction.removeFromParent()
        let explodeAction = SKAction.run({self.explode(scale: 0.5, position:CGPoint(x:0,y:0))})
        let fadeAction = SKAction.fadeOut(withDuration: 0.5)
        
        self.run(SKAction.sequence([explodeAction, SKAction.wait(forDuration: 0.25), fadeAction, removeAction]))
    }
}
