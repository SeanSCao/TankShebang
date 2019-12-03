//
//  Player.swift
//  TankShebang
//
//  Created by Sean Cao on 12/2/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import Foundation

import SpriteKit

class Player: SKSpriteNode {
    
    var directionState:String = "forward"
    var health:Int = 2
    var invincible:Bool = false
    var shield:Bool = false
    var ammo:Int = 4
    
    var roundScore:Int = 0
    var gameScore:Int = 0
    
    
    func addShield(){
        if (!shield) {
            let Circle = SKShapeNode(circleOfRadius: self.size.height) // Size of Circle
            Circle.name = "shield"
            Circle.position = CGPoint(x:0,y:0)  //Middle of Screen
            Circle.strokeColor = SKColor.blue
            Circle.glowWidth = 1.0
            //            Circle.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height)
            //            Circle.physicsBody?.isDynamic = false
            //            Circle.physicsBody?.categoryBitMask = PhysicsCategory.shield
            //            Circle.physicsBody?.contactTestBitMask = PhysicsCategory.shot
            //            Circle.physicsBody?.collisionBitMask = PhysicsCategory.none
            self.addChild(Circle)
            shield = true
        }
    }
    
    // Moves tank forward forward or backward
    func drive(tankMoveSpeed:CGFloat) {
        
        if (health > 0){
            var direction: CGPoint
            
            // some basic trigonometry to calculate direction tanks are moving
            if ( directionState == "forward" ) {
                direction = CGPoint(x:self.position.x - sin(self.zRotation) * tankMoveSpeed,y:self.position.y + cos(self.zRotation) * tankMoveSpeed)
            } else {
                direction = CGPoint(x:self.position.x + sin(self.zRotation) * tankMoveSpeed,y:self.position.y - cos(self.zRotation) * tankMoveSpeed)
            }
            
            let moveTank = SKAction.move(to: direction, duration:0)
            
            
            self.run(moveTank)
        }
    }
    
    func hit() {
        
        if (shield) {
            if let shieldNode = self.childNode(withName: "shield") as? SKShapeNode {
                shieldNode.removeFromParent()
            }
            shield = false
        } else {
            if (!invincible){
                health -= 1
            }
        }
        
        if (health == 0){
            self.removeFromParent()
        } else {
            temporaryInvincibility()
        }
    }
    
    func temporaryInvincibility() {
        let fadeOut = SKAction.fadeAlpha(to: 0.4, duration: 0.25)
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.25)
        
        let seq:SKAction = SKAction.sequence( [ fadeOut, fadeIn ])
        
        self.run(seq)
        
        invincible = true
        
        let seconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.invincible = false
        }
    }
    
//    func fireProjectile() {
//
//        print(self.zRotation)
//        print(sin(self.zRotation))
//        print(cos(self.zRotation))
//
//        if ( self.ammo > 0 ) {
//            let projectile = SKSpriteNode(imageNamed: "defaultProjectile")
//            let direction = CGPoint(x:-1*sin(self.zRotation) * 2000,y:cos(self.zRotation) * 2000)
//            let xDirection = self.position.x - sin(self.zRotation) + (-35 * sin(self.zRotation))
//            let yDirection = self.position.y + cos(self.zRotation) + (35 * cos(self.zRotation))
//
//            projectile.position = CGPoint(x: xDirection,y:yDirection)
//
//            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
//            projectile.physicsBody?.isDynamic = true
//            projectile.physicsBody?.categoryBitMask = PhysicsCategory.shot
//            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.p1 | PhysicsCategory.p2 | PhysicsCategory.p3 | PhysicsCategory.p4 | PhysicsCategory.obstacle
//            projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
//            projectile.physicsBody?.usesPreciseCollisionDetection = true
//
//            addChild(projectile)
//
//            let shoot = SKAction.move(to: direction, duration: 2.0)
//            let shootDone = SKAction.removeFromParent()
//            projectile.run(SKAction.sequence([shoot, shootDone]))
//
//            self.ammo -= 1
//        }
//    }
    
    @objc func reload() {
        self.ammo += 1
    }
    
}
