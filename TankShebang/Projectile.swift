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
    
    func explode(radius:CGFloat){
        let Circle = SKShapeNode(circleOfRadius: radius) // Size of Circle
        Circle.position = CGPoint(x:self.position.x,y:self.position.y)
        Circle.strokeColor = SKColor.white
        Circle.fillColor = SKColor.white
        Circle.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height)
        Circle.physicsBody?.isDynamic = false
        Circle.physicsBody?.categoryBitMask = PhysicsCategory.explosion
        Circle.physicsBody?.contactTestBitMask = PhysicsCategory.player
        Circle.physicsBody?.collisionBitMask = PhysicsCategory.none
        self.parent?.addChild(Circle)
    }
    
    func activateMine(){
        let rotateAction = SKAction.rotate(toAngle: 10 * .pi, duration: 1)
        let removeAction = SKAction.removeFromParent()
        let explodeAction = SKAction.run({self.explode(radius:50)})
        self.run(SKAction.sequence([rotateAction, removeAction, explodeAction]))
    }
}
