//
//  GameScene.swift
//  TankShebang
//
//  Created by Sean Cao on 11/5/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import SpriteKit
import GameplayKit
func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene {

    let player1 = SKSpriteNode(imageNamed: "tank") //player 1 tank
    let player1Right = SKSpriteNode(imageNamed: "red") //player 1 shoot button
    let player1Left = SKSpriteNode(imageNamed: "red") //player 1 turn button
    var p1LeftPressed = false
    var p1RightPressed = false
    
    let player2 = SKSpriteNode(imageNamed: "tank") //player 2 tank
    let player2Right = SKSpriteNode(imageNamed: "red") //player 2 shoot button
    let player2Left = SKSpriteNode(imageNamed: "red") //player 2 turn button
    var p2LeftPressed = false
    var p2RightPressed = false
    var TerrainType = "Rock"
    var SoundType = "On"
    var PowerupType = "On"
    let tankRotateSpeed = 0.1 //tank turning speed
    
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        NSLog(TerrainType)
        NSLog(SoundType)
        NSLog(PowerupType)

        // player 1 tank and button positioning
        player1.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        player1Left.position = CGPoint(x: player1Left.size.width/2, y: player1Left.size.height/2)
        player1Right.position = CGPoint(x: size.width - player1Right.size.width/2, y: player1Right.size.height/2)
        
        player1Right.zRotation += .pi/2
        
        player1Right.alpha = 0.6
        player1Left.alpha = 0.6
        
        addChild(player1)
        addChild(player1Right)
        addChild(player1Left)
        
        // player 2 tank and button positioning
        player2.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
        player2Left.position = CGPoint(x: size.width - player2Left.size.width/2, y: size.height - player2Left.size.height/2)
        player2Right.position = CGPoint(x: player2Right.size.width/2, y: size.height - player2Right.size.height/2)
        
        player2.zRotation += .pi
        player2Left.zRotation += .pi
        player2Right.zRotation -= .pi/2
        
        player2Right.alpha = 0.6
        player2Left.alpha = 0.6
        
        addChild(player2)
        addChild(player2Right)
        addChild(player2Left)

        
//        run(SKAction.repeatForever(
//            SKAction.run(moveTanksForward)
//        ))

        
    }
    
    // Moves tank forward in the direction it is facing
    func moveTanksForward() {
        // some basic trigonometry to calculate direction tanks are moving
        let p1Direction = CGPoint(x:player1.position.x - sin(player1.zRotation) * 3,y:player1.position.y + cos(player1.zRotation) * 3)
        let p2Direction = CGPoint(x:player2.position.x - sin(player2.zRotation) * 3,y:player2.position.y + cos(player2.zRotation) * 3)
        
        let moveTank1 = SKAction.move(to: p1Direction, duration:0)
        let moveTank2 = SKAction.move(to: p2Direction, duration:0)
        
        player1.run(moveTank1)
        player2.run(moveTank2)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in:self)
            // player 1 turn button pressed
            if (player1Left.contains(location)){
                p1LeftPressed = true
            }
            // player 1 shoot button pressed
            else if (player1Right.contains(location)){
                p1RightPressed = true
            }
            
            // player 2 turn button pressed
            if (player2Left.contains(location)){
                p2LeftPressed = true
            }
            // player 2 shoot button pressed
            else if (player2Right.contains(location)){
                p2RightPressed = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        for touch in touches {
            let location = touch.location(in:self)
            // if player 1 turn button no longer pressed
            if (player1Left.contains(location)){
                p1LeftPressed = true
            }
            else{
                p1LeftPressed = false
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        var player = 0;
        for touch in touches {
            let location = touch.location(in:self)
            // if player 1 turn button no longer pressed
            if (player1Left.contains(location)){
                
                p1LeftPressed = false
            }
            if (player2Left.contains(location)){
                
                p2LeftPressed = false
            }
            if (player1Right.contains(location)){
                player = 1
                p1LeftPressed = false
            }
            if (player2Right.contains(location)){
                player = 2
                p1LeftPressed = false
            }
        }
        //guard let touch = touches.first else {
         //   return
        //}
        //let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "projectile")
        var direc = CGPoint(x:player1.position.x - sin(player1.zRotation) * 3,y:player1.position.y + cos(player1.zRotation) * 3)
        if(player == 1){
           projectile.position = player1.position
            
             direc = CGPoint(x:player1.position.x - sin(player1.zRotation) * 3,y:player1.position.y + cos(player1.zRotation) * 3)
            
        }
        if(player == 2){
            projectile.position = player2.position
             direc = CGPoint(x:player2.position.x - sin(player2.zRotation) * 3,y:player2.position.y + cos(player2.zRotation) * 3)
        }
       
        
        
        // 3 - Determine offset of location to projectile
        let offset = projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if offset.x < 0 { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        
        // 7 - Make it shoot far enough to be guaranteed off screen
      
        // 9 - Create the actions
        let actionMove = SKAction.move(to: direc, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        // move all tanks forward
        run(SKAction.run(moveTanksForward))
        
        // player 1 turn
        if (p1LeftPressed) {
            player1.zRotation += CGFloat(tankRotateSpeed)
        }
        if (p2LeftPressed) {
            player2.zRotation += CGFloat(tankRotateSpeed)
        }
        // player 1 shoot
        if (p1RightPressed) {
//            player1.zRotation = CGFloat(0-tankRotateSpeed)
        }
    }
}
