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
        let playableHeight = size.width
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y:playableMargin, width: size.width, height:playableHeight)
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var numberOfPlayers = 4
    var players = [SKSpriteNode]()
    let playerSprites = ["tank", "tank", "tank", "tank"]
    var rightButtons = [SKShapeNode]()
    var leftButtons = [SKShapeNode]()
    var leftPressed = [false, false, false, false]
    
    let tankMoveSpeed = CGFloat(3)
    let tankRotateSpeed = 0.1 //tank turning speed
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        
        initPlayers()
        
        initButtons()
        
        debugDrawPlayableArea()
        
    }
    
    // create sprite node for each player tank and position accordingly
    func initPlayers(){
        let playableHeight = size.width
        let playableMargin = (size.height-playableHeight)/2.0
        
        for i in 1...numberOfPlayers {
            let player = SKSpriteNode(imageNamed: playerSprites[i-1]) //player tank
            
            // position for different corners of play area
            let bottomLeftCorner = CGPoint(x: size.width * 0.05, y: playableMargin + size.width * 0.05)
            let bottomRightCorner = CGPoint(x: size.width * 0.95, y: playableMargin + size.width * 0.05)
            let topLeftCorner = CGPoint(x: size.width * 0.05, y: playableMargin + size.width * 0.95)
            let topRightCorner = CGPoint(x: size.width * 0.95, y: playableMargin + size.width * 0.95)
            
            if (numberOfPlayers==2){ // 2 player game
                if (i==1){
                    // player 1 tank positioning
                    player.position = bottomLeftCorner
                    
                    player.zRotation += .pi * 7/4
                }
                
                if (i==2){
                    // player 2 tank positioning
                    player.position = topRightCorner
                    
                    player.zRotation += .pi * 3/4
                }
            } else if( numberOfPlayers == 3 ){ // 3 player game
                if (i==1){
                    // player 1 tank positioning
                    player.position = bottomLeftCorner
                    
                    player.zRotation += .pi * 7/4
                }
                
                if (i==2){
                    // player 2 tank position
                    player.position = topLeftCorner
                    player.zRotation += .pi * 5/4
                }
                
                if (i==3){
                    // player 2 tank position
                    player.position = topRightCorner
                    player.zRotation += .pi * 3/4
                }
                
            } else { // 4 player game
                if (i==1){
                    // player 1 tank positioning
                    player.position = bottomLeftCorner
                    
                    player.zRotation += .pi * 7/4
                }
                
                if (i==2){
                    // player 2 tank position
                    player.position = bottomRightCorner
                    player.zRotation += .pi * 1/4
                }
                
                if (i==3){
                    // player 2 tank position
                    player.position = topRightCorner
                    player.zRotation += .pi * 3/4
                }
                if (i==4){
                    // player 2 tank position
                    player.position = topLeftCorner
                    player.zRotation += .pi * 5/4
                }
                
            }
            addChild(player)
            players.append(player)
        }
    }
    
    // create large triangle shape node button
    func createTriangle() -> SKShapeNode{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: size.width * 0.2, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: size.width * 0.2))
        path.addLine(to: CGPoint(x: 0.0, y: 0.0))
        let triangle = SKShapeNode(path: path.cgPath)
        return triangle
    }
    
    // create small triangle shape node left button
    func createSmallLeftTriangle() -> SKShapeNode{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: size.width * 0.1, y: size.width * 0.1))
        path.addLine(to: CGPoint(x: 0.0, y: size.width * 0.2))
        path.addLine(to: CGPoint(x: 0.0, y: 0.0))
        let triangle = SKShapeNode(path: path.cgPath)
        return triangle
    }
    
    // create small triangle shape node rightbutton
    func createSmallRightTriangle() -> SKShapeNode{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: size.width * 0.2, y: 0))
        path.addLine(to: CGPoint(x: size.width * 0.1, y: size.width * 0.1))
        path.addLine(to: CGPoint(x: 0.0, y: 0.0))
        let triangle = SKShapeNode(path: path.cgPath)
        return triangle
    }
    
    // create shape nodes for control buttons
    func initButtons(){
        var playerLeft:SKShapeNode
        var playerRight:SKShapeNode
        for i in 1...numberOfPlayers {
            if (numberOfPlayers==2){ // 2 player game use large buttons
                playerLeft = createTriangle()
                playerRight = createTriangle()
                if (i==1){
                    // player 1 button positioning
                    playerLeft.fillColor = SKColor.black
                    playerRight.fillColor = SKColor.black
                    playerLeft.position = CGPoint(x:0, y:0)
                    playerRight.position = CGPoint(x:size.width, y:0)
                    playerRight.zRotation += .pi/2
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                } else if (i==2){
                    // player 2 button positioning
                    playerLeft.fillColor = SKColor.red
                    playerRight.fillColor = SKColor.red
                    playerLeft.position = CGPoint(x:size.width, y:size.height)
                    playerRight.position = CGPoint(x:0, y:size.height)
                    playerLeft.zRotation += .pi
                    playerRight.zRotation -= .pi/2
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                }
            } else if (numberOfPlayers==3){ // 3 player game use mix of large and small buttons
                if (i==1){
                    // player 1 button positioning
                    playerLeft = createTriangle()
                    playerRight = createTriangle()
                    playerLeft.fillColor = SKColor.black
                    playerRight.fillColor = SKColor.black
                    playerLeft.position = CGPoint(x:0, y:0)
                    playerRight.position = CGPoint(x:size.width, y:0)
                    playerRight.zRotation += .pi/2
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                } else if (i==2) {
                    // player 2 button positioning
                    playerLeft = createSmallLeftTriangle()
                    playerRight = createSmallRightTriangle()
                    playerLeft.fillColor = SKColor.red
                    playerRight.fillColor = SKColor.red
                    playerLeft.position = CGPoint(x:0, y:size.height)
                    playerRight.position = CGPoint(x:0, y:size.height)
                    playerLeft.zRotation += .pi * 3/2
                    playerRight.zRotation += .pi * 3/2
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                } else {
                    playerLeft = createSmallLeftTriangle()
                    playerRight = createSmallRightTriangle()
                    playerLeft.fillColor = SKColor.blue
                    playerRight.fillColor = SKColor.blue
                    playerLeft.position = CGPoint(x:size.width, y:size.height)
                    playerRight.position = CGPoint(x:size.width, y:size.height)
                    playerLeft.zRotation += .pi * 2/2
                    playerRight.zRotation += .pi * 2/2
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                }
            } else { // 4 player game use small buttons
                playerLeft = createSmallLeftTriangle()
                playerRight = createSmallRightTriangle()
                if (i==1){
                    // player 1 button positioning
                    playerLeft.fillColor = SKColor.black
                    playerRight.fillColor = SKColor.black
                    playerLeft.position = CGPoint(x:0, y:0)
                    playerRight.position = CGPoint(x:0, y:0)
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                } else if (i==2) {
                    // player 2 button positioning
                    playerLeft.fillColor = SKColor.red
                    playerRight.fillColor = SKColor.red
                    playerLeft.position = CGPoint(x:size.width, y:0)
                    playerRight.position = CGPoint(x:size.width, y:0)
                    playerLeft.zRotation += .pi * 1/2
                    playerRight.zRotation += .pi * 1/2
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                } else if (i==3){
                    playerLeft.fillColor = SKColor.blue
                    playerRight.fillColor = SKColor.blue
                    playerLeft.position = CGPoint(x:size.width, y:size.height)
                    playerRight.position = CGPoint(x:size.width, y:size.height)
                    playerLeft.zRotation += .pi
                    playerRight.zRotation += .pi
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                } else {
                    playerLeft.fillColor = SKColor.green
                    playerRight.fillColor = SKColor.green
                    playerLeft.position = CGPoint(x:0, y:size.height)
                    playerRight.position = CGPoint(x:0, y:size.height)
                    playerLeft.zRotation += .pi * 3/2
                    playerRight.zRotation += .pi * 3/2
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                }
            }
            
            addChild(playerLeft)
            addChild(playerRight)
            
            
            leftButtons.append(playerLeft)
            rightButtons.append(playerRight)
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
            var direction : CGPoint
            
            // some basic trigonometry to calculate direction tanks are moving
            if (i==1){
                direction = CGPoint(x:players[i-1].position.x - sin(players[i-1].zRotation) * tankMoveSpeed,y:players[i-1].position.y + cos(players[i-1].zRotation) * tankMoveSpeed)
            } else if (i==2){
                direction = CGPoint(x:players[i-1].position.x - sin(players[i-1].zRotation) * tankMoveSpeed,y:players[i-1].position.y + cos(players[i-1].zRotation) * tankMoveSpeed)
            } else if (i==3){
                direction = CGPoint(x:players[i-1].position.x - sin(players[i-1].zRotation) * tankMoveSpeed,y:players[i-1].position.y + cos(players[i-1].zRotation) * tankMoveSpeed)
            } else {
                direction = CGPoint(x:players[i-1].position.x - sin(players[i-1].zRotation) * tankMoveSpeed,y:players[i-1].position.y + cos(players[i-1].zRotation) * tankMoveSpeed)
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
                if (leftButtons[i-1].contains(location)){
                    leftPressed[i-1] = true
                }
                
                if (rightButtons[i-1].contains(location)){
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
                if (leftButtons[i-1].contains(location)){
                    leftPressed[i-1] = true
                } else{
                    leftPressed[i-1] = false
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        for touch in touches {
            let location = touch.location(in:self)
            
            for i in 1...numberOfPlayers {
                if (leftButtons[i-1].contains(location)){
                    leftPressed[i-1] = false
                }
                
                if (rightButtons[i-1].contains(location)){
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
            if (leftPressed[i-1]){
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
