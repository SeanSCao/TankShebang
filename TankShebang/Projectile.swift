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
    
    func explode(radius:CGFloat, position: CGPoint){
        self.texture = SKTexture(imageNamed: "Explosion")
        self.zPosition = 101
        self.setScale(6)
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.explosion
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
    }
    
    func activateMine(){
        let rotateAction = SKAction.rotate(toAngle: 10 * .pi, duration: 1)
        let removeAction = SKAction.removeFromParent()
        let explodeAction = SKAction.run({self.explode(radius:50, position:CGPoint(x:0,y:0))})
        let fadeAction = SKAction.fadeOut(withDuration: 0.5)
        self.run(SKAction.sequence([rotateAction, explodeAction, SKAction.wait(forDuration: 0.25), fadeAction, removeAction]))
    }
}
