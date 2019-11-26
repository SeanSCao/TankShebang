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
    
    // Initialize the playable space, makes sure to fit all devices
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
    
    var numberOfPlayers = 2
    var players = [SKSpriteNode]()
    var playerRightButtons = [SKSpriteNode]()
    var playerLeftButtons = [SKSpriteNode]()
    var playerLeftPressed = [false, false, false, false]
    
    let tankMoveSpeed = CGFloat(3)
    let tankRotateSpeed = 0.1 //tank turning speed
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        
        initPlayers()
        
        debugDrawPlayableArea()
        
    }
    
    func initPlayers(){
        
        for i in 1...numberOfPlayers {
            let player = SKSpriteNode(imageNamed: "tank") //player tank
            let playerLeft = SKSpriteNode(imageNamed: "red") //player turn button
            let playerRight = SKSpriteNode(imageNamed: "red") //player shoot button
            
            
            if (i==1){
                // player 1 tank and button positioning
                player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
                playerLeft.position = CGPoint(x: playerLeft.size.width/2, y: playerLeft.size.height/2)
                playerRight.position = CGPoint(x: size.width - playerRight.size.width/2, y: playerRight.size.height/2)
                
                playerRight.zRotation += .pi/2
                
                playerRight.alpha = 0.6
                playerLeft.alpha = 0.6
                
                addChild(player)
                addChild(playerRight)
                addChild(playerLeft)
            }
            
            if (i==2){
                // player 2 tank and button positioning
                player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
                playerLeft.position = CGPoint(x: size.width - playerLeft.size.width/2, y: size.height - playerLeft.size.height/2)
                playerRight.position = CGPoint(x: playerRight.size.width/2, y: size.height - playerRight.size.height/2)
                
                player.zRotation += .pi
                playerLeft.zRotation += .pi
                playerRight.zRotation -= .pi/2
                
                playerRight.alpha = 0.6
                playerLeft.alpha = 0.6
                
                addChild(player)
                addChild(playerRight)
                addChild(playerLeft)
            }
            
            players.append(player)
            playerLeftButtons.append(playerLeft)
            playerRightButtons.append(playerRight)
        }
        
    }
    
    func boundsChecktanks(){
        let bottomLeft = CGPoint(x:0, y:playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        
        for i in 1...numberOfPlayers {
            
            if players[i-1].position.x <= bottomLeft.x {
                players[i-1].position.x = bottomLeft.x
            }
            if players[i-1].position.x >= topRight.x {
                players[i-1].position.x = topRight.x
            }
            if players[i-1].position.y <= bottomLeft.y {
                players[i-1].position.y = bottomLeft.y
            }
            if players[i-1].position.y >= topRight.y {
                players[i-1].position.y = topRight.y
            }
        }
    }
    
    // Moves tank forward in the direction it is facing
    func moveTanksForward() {
        
        for i in 1...numberOfPlayers {
            var direction = CGPoint(x: 0, y:0)
            
            // some basic trigonometry to calculate direction tanks are moving
            if (i==1){
                direction = CGPoint(x:players[0].position.x - sin(players[0].zRotation) * tankMoveSpeed,y:players[0].position.y + cos(players[0].zRotation) * tankMoveSpeed)
            }
            
            if (i==2){
                direction = CGPoint(x:players[1].position.x - sin(players[1].zRotation) * tankMoveSpeed,y:players[1].position.y + cos(players[1].zRotation) * tankMoveSpeed)
            }
            
            let moveTank = SKAction.move(to: direction, duration:0)
            players[i-1].run(moveTank)
        }
    }
    
    // fire projectile in direction player tank is facing
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
            
            for i in 1...numberOfPlayers {
                if (playerLeftButtons[i-1].contains(location)){
                    playerLeftPressed[i-1] = true
                }
                
                if (playerRightButtons[i-1].contains(location)){
                    fireProjectile(player: players[i-1])
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        for touch in touches {
            let location = touch.location(in:self)
            
            for i in 1...numberOfPlayers {
                if (playerLeftButtons[i-1].contains(location)){
                    playerLeftPressed[i-1] = true
                } else{
                    playerLeftPressed[i-1] = false
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        for touch in touches {
            let location = touch.location(in:self)
            
            for i in 1...numberOfPlayers {
                if (playerLeftButtons[i-1].contains(location)){
                    playerLeftPressed[i-1] = false
                }
                
                if (playerRightButtons[i-1].contains(location)){
                }
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
        
        for i in 1...numberOfPlayers {
            if (playerLeftPressed[i-1]){
                players[i-1].zRotation += CGFloat(tankRotateSpeed)
            }
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
