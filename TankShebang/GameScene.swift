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
    let playableRect: CGRect
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/19.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y:playableMargin, width: size.width, height:playableHeight)
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    let tankMoveSpeed = CGFloat(3)
    let tankRotateSpeed = 0.1 //tank turning speed
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        
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
        
        debugDrawPlayableArea()
        
    }
    
    func boundsChecktanks(){
        let bottomLeft = CGPoint(x:0, y:playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        
        if player1.position.x <= bottomLeft.x {
            player1.position.x = bottomLeft.x
        }
        if player1.position.x >= topRight.x {
            player1.position.x = topRight.x
        }
        if player1.position.y <= bottomLeft.y {
            player1.position.y = bottomLeft.y
        }
        if player1.position.y >= topRight.y {
            player1.position.y = topRight.y
        }
        
        if player2.position.x <= bottomLeft.x {
            player2.position.x = bottomLeft.x
        }
        if player2.position.x >= topRight.x {
            player2.position.x = topRight.x
        }
        if player2.position.y <= bottomLeft.y {
            player2.position.y = bottomLeft.y
        }
        if player2.position.y >= topRight.y {
            player2.position.y = topRight.y
        }
        
    }
    
    // Moves tank forward in the direction it is facing
    func moveTanksForward() {
        // some basic trigonometry to calculate direction tanks are moving
        let p1Direction = CGPoint(x:player1.position.x - sin(player1.zRotation) * tankMoveSpeed,y:player1.position.y + cos(player1.zRotation) * tankMoveSpeed)
        let p2Direction = CGPoint(x:player2.position.x - sin(player2.zRotation) * tankMoveSpeed,y:player2.position.y + cos(player2.zRotation) * tankMoveSpeed)
        
        let moveTank1 = SKAction.move(to: p1Direction, duration:0)
        let moveTank2 = SKAction.move(to: p2Direction, duration:0)
        
        player1.run(moveTank1)
        player2.run(moveTank2)
    }
    
    func fireProjectile(player: SKSpriteNode) {
        let projectile = SKSpriteNode(imageNamed: "defaultProjectile")
        let direction = CGPoint(x:player.position.x - sin(player.zRotation) * 1000,y:player.position.y + cos(player.zRotation) * 1000)
        projectile.position = player.position
        
        addChild(projectile)
        
        let shoot = SKAction.move(to: direction, duration: 2.0)
        let shootDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([shoot, shootDone]))
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
                //                p1RightPressed = true
                fireProjectile(player: player1)
            }
            
            // player 2 turn button pressed
            if (player2Left.contains(location)){
                p2LeftPressed = true
            }
                // player 2 shoot button pressed
            else if (player2Right.contains(location)){
                //                p2RightPressed = true
                fireProjectile(player: player2)
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
            }
            if (player2Right.contains(location)){
            }
        }
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
        
        boundsChecktanks()
    }
    
    func debugDrawPlayableArea(){
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.black
        shape.lineWidth = 4.0
        addChild(shape)
        
    }
}
