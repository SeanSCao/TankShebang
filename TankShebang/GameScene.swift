//
//  GameScene.swift
//  TankShebang
//
//  Created by Sean Cao on 11/5/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let player1 = SKSpriteNode(imageNamed: "tank")
    let player1Right = SKSpriteNode(imageNamed: "redRight")
    let player1Left = SKSpriteNode(imageNamed: "redLeft")
    var p1leftPressed = false
    var p1rightPressed = false
    
    let player2 = SKSpriteNode(imageNamed: "tank")
    
    let tankRotateSpeed = 0.02
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        
        player1.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        player1Right.position = CGPoint(x: size.width - player1Right.size.width/2, y: player1Right.size.height/2)
        player1Left.position = CGPoint(x: player1Left.size.width/2, y: player1Left.size.height/2)
        player1Right.alpha = 0.6
        player1Left.alpha = 0.6
        addChild(player1)
        addChild(player1Right)
        addChild(player1Left)
        
        player2.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
        addChild(player2)
        
//        run(SKAction.repeatForever(
//            SKAction.run(moveTanksForward)
//        ))
        
    }
    
    // Moves tank forward in the direction it is facing
    func moveTanksForward() {
        let dest1 = CGPoint(x:player1.position.x - sin(player1.zRotation) * 5,y:player1.position.y + cos(player1.zRotation) * 5)
        let dest2 = CGPoint(x:player2.position.x + sin(player2.zRotation) * 5,y:player2.position.y - cos(player2.zRotation) * 5)
        let moveTank1 = SKAction.move(to: dest1, duration:0.1)
        let moveTank2 = SKAction.move(to: dest2, duration:0.1)
        player1.run(moveTank1)
//        player2.run(moveTank2)
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
            if (player1Left.contains(location)){
                p1leftPressed = true
//                let rotateAction = SKAction.rotate(byAngle: CGFloat(tankRotateSpeed), duration: 0)
//                player1.run(rotateAction)
            }
            
            else if (player1Right.contains(location)){
                p1rightPressed = true
            }
//            else {
//                var move = SKAction.move(to:location, duration:1.0)
//                player1.run(move)
//            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        for touch in touches {
            let location = touch.location(in:self)
            if (player1Left.contains(location)){
                p1leftPressed = true
            }
            else{
                p1leftPressed = false
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        for touch in touches {
            let location = touch.location(in:self)
            if (player1Left.contains(location)){
                p1leftPressed = false
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if (p1leftPressed) {
            player1.zRotation += CGFloat(tankRotateSpeed)
        } else if (p1rightPressed) {
            run(SKAction.run(moveTanksForward))
//            player1.zRotation = CGFloat(0-tankRotateSpeed)
        }
    }
}
