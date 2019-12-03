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
    
    var health:Int = 2
    var invincible:Bool = false
    var shield:Bool = false
    var ammo:Int = 4
    
    
    
    // Moves tank forward in the direction it is facing
    func drive(tankMoveSpeed:CGFloat) {
        
        // some basic trigonometry to calculate direction tanks are moving
        let direction = CGPoint(x:self.position.x - sin(self.zRotation) * tankMoveSpeed,y:self.position.y + cos(self.zRotation) * tankMoveSpeed)
        
        let moveTank = SKAction.move(to: direction, duration:0)
        
        if (health > 0){
            self.run(moveTank)
        }
    }
    
    func hit() {
        if (!invincible){
            health -= 1
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
    
    @objc func reload() {
        self.ammo += 1
    }
    
}
