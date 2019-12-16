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
    
    var SFX:Bool = true
    
    var colorString:String = ""
    var health:Int = 2
    var invincible:Bool = false
    var shield:Bool = false
    var ammo:Int = 4
    var powerup:String = ""
    
    var gameScale:CGFloat = 1
    var roundScore:Int = 0
    var gameScore:Int = 0
    
    //Add shield
    func addShield(){
        if (!shield) {
            
            let shieldSprite = SKSpriteNode(imageNamed: "Shield")
            shieldSprite.name = "shield"
            shieldSprite.position = CGPoint(x:0,y:0)
            self.addChild(shieldSprite)
            shield = true
            
            if (self.SFX){
                let sound = SKAudioNode(fileNamed: "reverse.mp3")
                sound.autoplayLooped = false
                self.addChild(sound)
                self.run(SKAction.run {sound.run(SKAction.play())})
            }
            
        }
    }
    
    //Remove shield
    func removeShield() {
        if let shieldNode = self.childNode(withName: "shield") as? SKSpriteNode {
            shieldNode.removeFromParent()
        }
        shield = false
    }
    
    // Moves tank forward forward or backward
    func drive(tankDriveForward:Bool, tankMoveSpeed:CGFloat) {
        
        if (health > 0){
            var direction: CGPoint
            
            // some basic trigonometry to calculate direction tanks are moving
            if ( tankDriveForward ) {
                direction = CGPoint(x:self.position.x - sin(self.zRotation) * tankMoveSpeed,y:self.position.y + cos(self.zRotation) * tankMoveSpeed)
            } else {
                direction = CGPoint(x:self.position.x + sin(self.zRotation) * tankMoveSpeed,y:self.position.y - cos(self.zRotation) * tankMoveSpeed)
            }
            
            let moveTank = SKAction.move(to: direction, duration:0)
            
            
            self.run(moveTank)
        }
    }
    
    //If shot by projectile
    func hit(projectile: Projectile) {
        
        // Calculate damage
        if (projectile.name == "Landmine" && projectile.owner != self){
            projectile.activateMine()
        } else if (projectile.name == "Rocket") {
            projectile.activateRocket()
            if (shield) {
                removeShield()
                if(projectile.owner == self){
                    projectile.owner.gameScore -= 10
                } else {
                    projectile.owner.gameScore += 10
                }
            } else {
                health = 0
                if(projectile.owner == self){
                    projectile.owner.gameScore -= 25
                } else {
                    projectile.owner.gameScore += 25
                }
            }
        } else if (shield) {
            removeShield()
            if(projectile.owner == self){
                projectile.owner.gameScore -= 10
            } else {
                projectile.owner.gameScore += 10
            }
        } else {
            if (!invincible){
                if (projectile.isLaser){
                    health = 0
                    projectile.owner.gameScore += 25
                } else {
                    health -= 1
                    if(projectile.owner == self){
                        projectile.owner.gameScore -= 10
                    } else {
                        projectile.owner.gameScore += 10
                    }
                    var spriteFile:String = ""
                    if (self.health == 2){
                        spriteFile = self.colorString + String(ammo)
                    } else {
                        spriteFile = self.colorString + "D" + String(ammo)
                    }
                    self.texture = SKTexture(imageNamed: spriteFile)
                    
                    if (self.SFX) {
                        let sound = SKAudioNode(fileNamed: "hit.mp3")
                        sound.autoplayLooped = false
                        self.addChild(sound)
                        self.run(SKAction.run {sound.run(SKAction.play())})
                    }
                }
            }
        }
        
        // Remove projectile from parent
        if (!projectile.isLaser && projectile.name != "Rocket"){
            projectile.removeFromParent()
        }
        
        // Calculate dead or not
        if (health == 0){
            if(projectile.owner == self){
                projectile.owner.gameScore -= 25
            } else {
                projectile.owner.gameScore += 25
            }
            self.removeFromParent()
        } else {
            temporaryInvincibility()
        }
    }
    
    //If touching an explosion
    func explode(explosion: Projectile) {
        // Calculate damage
        if (shield) {
            removeShield()
        } else {
            if (!invincible){
                health = 0
            }
        }
        
        var spriteFile:String = ""
        if (self.health == 2){
            spriteFile = self.colorString + String(ammo)
        } else {
            spriteFile = self.colorString + "D" + String(ammo)
        }
        self.texture = SKTexture(imageNamed: spriteFile)
        
        // Calculate dead or not
        if (health == 0){
            if(explosion.owner == self){
                explosion.owner.gameScore -= 25
            } else {
                explosion.owner.gameScore += 25
            }
            if (self.SFX) {
                let sound = SKAudioNode(fileNamed: "explosion.mp3")
                sound.autoplayLooped = false
                self.addChild(sound)
                self.run(SKAction.run {sound.run(SKAction.play())})
            }
            
            self.removeFromParent()
        } else {
            temporaryInvincibility()
        }
    }
    
    //Gain temporary invincibility after taking damage
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
    
    //Determine what projectile to shoot
    func fireProjectile() {
        if ( !self.powerup.isEmpty ){
            if (self.powerup == "Laser"){
                fireLaser()
            } else if (self.powerup == "Bubble"){
                fireBubble()
            } else if (self.powerup == "Landmine"){
                dropMine()
            } else if (self.powerup == "Rocket"){
                fireRocket()
            }
            self.powerup = ""
        } else if ( self.ammo > 0 ) {
            let projectile:Projectile = Projectile(imageNamed: "DefaultProjectile")
            projectile.owner = self
            projectile.SFX = self.SFX
            let direction = CGPoint(x:self.position.x - sin(self.zRotation) * 2000,y:self.position.y + cos(self.zRotation) * 2000)
            let xDirection = self.position.x - sin(self.zRotation) + (-40 * sin(self.zRotation))
            let yDirection = self.position.y + cos(self.zRotation) + (40 * cos(self.zRotation))

            projectile.position = CGPoint(x: xDirection,y:yDirection)

            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.obstacle
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
            projectile.physicsBody?.usesPreciseCollisionDetection = true

            self.parent?.addChild(projectile)

            let shoot = SKAction.move(to: direction, duration: 2.0)
            let shootDone = SKAction.removeFromParent()
            projectile.run(SKAction.sequence([shoot, shootDone]))

            self.ammo -= 1
            
            var spriteFile:String = ""
            if (self.health == 2){
                spriteFile = self.colorString + String(ammo)
            } else {
                spriteFile = self.colorString + "D" + String(ammo)
            }
            self.texture = SKTexture(imageNamed: spriteFile)
            
            if (self.SFX) {
                let sound = SKAudioNode(fileNamed: "shoot.mp3")
                sound.autoplayLooped = false
                self.addChild(sound)
                self.run(SKAction.run {sound.run(SKAction.play())})
            }
            
        }
    }
    
    //Fire laser
    func fireLaser() {
        let projectile:Projectile = Projectile(imageNamed: "Laser")
        projectile.owner = self
        projectile.isLaser = true
        projectile.SFX = self.SFX
        
        projectile.setScale(0.5*gameScale)
        projectile.zRotation = self.zRotation
        let direction = CGPoint(x:self.position.x - sin(self.zRotation) * 2000,y:self.position.y + cos(self.zRotation) * 2000)
        let xDirection = self.position.x - sin(self.zRotation) + (-100 * sin(self.zRotation))
        let yDirection = self.position.y + cos(self.zRotation) + (100 * cos(self.zRotation))

        projectile.position = CGPoint(x: xDirection,y:yDirection)

        projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.laser
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.player
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true

        self.parent?.addChild(projectile)

        let shoot = SKAction.move(to: direction, duration: 1.0)
        let shootDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([shoot, shootDone]))
        
        if (self.SFX) {
            let sound = SKAudioNode(fileNamed: "laser.mp3")
            sound.autoplayLooped = false
            self.addChild(sound)
            self.run(SKAction.run {sound.run(SKAction.play())})
        }
        
    }
    
    //Fire bubble
    func fireBubble(){
        let projectile:Projectile = Projectile(imageNamed: "Bubble")
        projectile.owner = self
        projectile.SFX = self.SFX
        let direction = CGPoint(x:self.position.x - sin(self.zRotation) * 2000,y:self.position.y + cos(self.zRotation) * 2000)
        let xDirection = self.position.x - sin(self.zRotation) + (-100 * sin(self.zRotation))
        let yDirection = self.position.y + cos(self.zRotation) + (100 * cos(self.zRotation))

        projectile.position = CGPoint(x: xDirection,y:yDirection)

        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.obstacle
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true

        self.parent?.addChild(projectile)

        let shoot = SKAction.move(to: direction, duration: 2.0)
        let shootDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([shoot, shootDone]))
        
        if (self.SFX) {
            let sound = SKAudioNode(fileNamed: "shoot.mp3")
            sound.autoplayLooped = false
            self.addChild(sound)
            self.run(SKAction.run {sound.run(SKAction.play())})
        }
        
    }
    
    //Fire a rocket
    func fireRocket(){
        let projectile:Projectile = Projectile(imageNamed: "Rocket")
        projectile.owner = self
        projectile.SFX = self.SFX
        projectile.name = "Rocket"
        projectile.zRotation = self.zRotation
        projectile.setScale(0.5*gameScale)
        let direction = CGPoint(x:self.position.x - sin(self.zRotation) * 2000,y:self.position.y + cos(self.zRotation) * 2000)
        let xDirection = self.position.x - sin(self.zRotation) + (-60 * sin(self.zRotation))
        let yDirection = self.position.y + cos(self.zRotation) + (60 * cos(self.zRotation))

        projectile.position = CGPoint(x: xDirection,y:yDirection)

        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.obstacle
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true

        self.parent?.addChild(projectile)

        let shoot = SKAction.move(to: direction, duration: 2.0)
        let shootDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([shoot, shootDone]))
        
        if (self.SFX) {
            let sound = SKAudioNode(fileNamed: "rocket.mp3")
            sound.autoplayLooped = false
            self.addChild(sound)
            self.run(SKAction.run {sound.run(SKAction.play())})
        }
        
    }
    
    //Drops a landmine on their position
    func dropMine(){
        let projectile:Projectile = Projectile(imageNamed: "Landmine")
        projectile.owner = self
        projectile.name = "Landmine"
        projectile.SFX = self.SFX
        
        projectile.setScale(gameScale)

        projectile.position = CGPoint(x: self.position.x,y:self.position.y)

        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.landmine
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.player
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true

        self.parent?.addChild(projectile)
    }
    
    //Add 1 ammo every second
    @objc func reload() {
        if (self.ammo < 4) {
            self.ammo += 1
            var spriteFile:String = ""
            if (self.health == 2){
                spriteFile = self.colorString + String(ammo)
            } else {
                spriteFile = self.colorString + "D" + String(ammo)
            }
            self.texture = SKTexture(imageNamed: spriteFile)
        }
        
    }
    
}
