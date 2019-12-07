//  GameScene.swift
//  TankShebang
//
//  Created by Sean Cao on 11/5/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let none         : UInt32 = 0
    static let all          : UInt32 = UInt32.max
    static let p1           : UInt32 = 0b1
    static let p2           : UInt32 = 0b10
    static let p3           : UInt32 = 0b11
    static let p4           : UInt32 = 0b100
    static let obstacle     : UInt32 = 0b101
    static let shot         : UInt32 = 0b110
    static let shield         : UInt32 = 0b111
}

class GameScene: SKScene {
    
    let gameLayer = SKNode()
    let pauseLayer = SKNode()
    
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
    
    var map = SKNode()
    let mapSetting = 2
    
    var numberOfPlayers = 4
    var players = [Player]()
    let playerSprites = ["tank", "tank", "tank", "tank"]
    
    var rightButtons = [SKShapeNode]()
    var leftButtons = [SKShapeNode]()
    var leftPressed = [false, false, false, false]
    
    let tankMoveSpeed = CGFloat(3)
    var tankTurnDirection = "left"
    let tankRotateSpeed = 0.1 //tank turning speed
    
    var startWithShield = false
    
    var countdownLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        
        addChild(gameLayer)
        
        addChild(pauseLayer)
        
        initMap()
        
        initPlayers()
        
        initButtons()
        
        drawPlayableArea()
        
        countdownLabel = SKLabelNode(fontNamed: "Arial")
        countdownLabel.name = "countdown"
        countdownLabel.horizontalAlignmentMode = .center
        countdownLabel.position = CGPoint(x:size.width/2, y:size.height/2)
        pauseLayer.addChild(countdownLabel)
        
        countdown()
        
        for player in players {
            Timer.scheduledTimer(timeInterval: 1, target: player, selector: #selector(player.reload), userInfo: nil, repeats: true)
        }
        
        players[0].addShield()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
    }
    
    // create sprite node for each player tank and position accordingly
    func initPlayers(){
        let gameScale = size.width / 1024
        
        for i in 1...numberOfPlayers {
            let player:Player = Player(imageNamed: playerSprites[i-1]) //player tank
            
            player.setScale(gameScale)
            
            player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
            player.physicsBody?.isDynamic = true
            player.physicsBody?.restitution = 1.0
            
            if(i==1) {
                player.physicsBody?.categoryBitMask = PhysicsCategory.p1
                player.physicsBody?.contactTestBitMask = PhysicsCategory.shot
                player.physicsBody?.collisionBitMask = PhysicsCategory.obstacle | PhysicsCategory.p2 | PhysicsCategory.p4 | PhysicsCategory.p4
            } else if(i==2) {
                player.physicsBody?.categoryBitMask = PhysicsCategory.p2
                player.physicsBody?.contactTestBitMask = PhysicsCategory.shot
                player.physicsBody?.collisionBitMask = PhysicsCategory.obstacle | PhysicsCategory.p1 | PhysicsCategory.p3 | PhysicsCategory.p4
            } else if(i==3) {
                player.physicsBody?.categoryBitMask = PhysicsCategory.p3
                player.physicsBody?.contactTestBitMask = PhysicsCategory.shot
                player.physicsBody?.collisionBitMask = PhysicsCategory.obstacle | PhysicsCategory.p1 | PhysicsCategory.p2 | PhysicsCategory.p4
            } else {
                player.physicsBody?.categoryBitMask = PhysicsCategory.p4
                player.physicsBody?.contactTestBitMask = PhysicsCategory.shot
                player.physicsBody?.collisionBitMask = PhysicsCategory.obstacle | PhysicsCategory.p1 | PhysicsCategory.p2 | PhysicsCategory.p3
            }
            players.append(player)
        }
        resetTanks()
    }
    
    func resetTanks(){
        let playableHeight = size.width
        let playableMargin = (size.height-playableHeight)/2.0
        
        // position for different corners of play area
        let bottomLeftCorner = CGPoint(x: size.width * 0.1, y: playableMargin + size.width * 0.1)
        let bottomRightCorner = CGPoint(x: size.width * 0.9, y: playableMargin + size.width * 0.1)
        let topLeftCorner = CGPoint(x: size.width * 0.1, y: playableMargin + size.width * 0.9)
        let topRightCorner = CGPoint(x: size.width * 0.9, y: playableMargin + size.width * 0.9)
        
        for i in 1...numberOfPlayers {
            players[i-1].removeFromParent()
            if (numberOfPlayers==2){ // 2 player game
                if (i==1){
                    // player 1 tank positioning
                    players[i-1].position = bottomLeftCorner
                    
                    players[i-1].zRotation = 0
                }
                
                if (i==2){
                    // player 2 tank positioning
                    players[i-1].position = topRightCorner
                    
                    players[i-1].zRotation = .pi
                }
            } else if( numberOfPlayers == 3 ){ // 3 player game
                if (i==1){
                    // player 1 tank positioning
                    players[i-1].position = bottomLeftCorner
                    
                    players[i-1].zRotation = 0
                }
                
                if (i==2){
                    // player 2 tank position
                    players[i-1].position = topLeftCorner
                    players[i-1].zRotation = .pi * 3/2
                }
                
                if (i==3){
                    // player 2 tank position
                    players[i-1].position = topRightCorner
                    players[i-1].zRotation = .pi
                }
                
            } else { // 4 player game
                if (i==1){
                    // player 1 tank positioning
                    players[i-1].position = bottomLeftCorner
                    
                    players[i-1].zRotation = 0
                }
                
                if (i==2){
                    // player 2 tank position
                    players[i-1].position = bottomRightCorner
                    players[i-1].zRotation = .pi * 1/2
                }
                
                if (i==3){
                    // player 2 tank position
                    players[i-1].position = topRightCorner
                    players[i-1].zRotation = .pi
                }
                if (i==4){
                    // player 2 tank position
                    players[i-1].position = topLeftCorner
                    players[i-1].zRotation = .pi * 3/2
                }
                
            }
            players[i-1].health = 2
            players[i-1].ammo = 4
            players[i-1].invincible = false
            players[i-1].shield = startWithShield
            gameLayer.addChild(players[i-1])
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
            
            gameLayer.addChild(playerLeft)
            gameLayer.addChild(playerRight)
            
            
            leftButtons.append(playerLeft)
            rightButtons.append(playerRight)
        }
    }
    
    // add map background textures
    func initMap() {
        let gameScale = size.width / 1024
        let playableHeight = size.width
        let playableMargin = (size.height-playableHeight)/2.0
        
        gameLayer.addChild(map)
        map.xScale = 0.5 * gameScale
        map.yScale = 0.5 * gameScale
        
        map.position = CGPoint(x:0,y:playableMargin)
        
        changeMap()
    }
    
    func changeMap() {
        let tileSet = SKTileSet(named: "Grid Tile Set")!
        let tileSize = CGSize(width: 128, height: 128)
        let columns = 32
        let rows = 48
        
        if let bottomLayerNode = map.childNode(withName: "background") as? SKTileMapNode {
            bottomLayerNode.removeFromParent()
        }
        
        let bottomLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        bottomLayer.name = "background"
        
        if (mapSetting == 1) {
            let grassTiles = tileSet.tileGroups.first { $0.name == "Grass" }
            bottomLayer.fill(with: grassTiles)
        } else if (mapSetting == 1) {
            let dirtTiles = tileSet.tileGroups.first { $0.name == "Dirt"}
            bottomLayer.fill(with: dirtTiles)
        } else {
            let dirtTiles = tileSet.tileGroups.first { $0.name == "Dirt"}
            bottomLayer.fill(with: dirtTiles)
        }

        map.addChild(bottomLayer)
    }
    
    func checkRoundOver() -> Bool {
        var alive = 0
        for player in players{
            if ( player.health > 0 ){
                alive += 1
            }
        }
        
        if ( alive > 1 ){
            return false
        } else {
            return true
        }
    }
    
    func newRound(){
        for player in players{
            if ( player.health > 0 ){
                player.roundScore += 1
                player.gameScore += 100
            }
        }
        
        if ( !checkGameOver() ) {
            resetTanks()
            changeMap()
        } else {
            
        }
    }
    
    func countdown() {
        pauseGame()

        var offset: Double = 0

        for x in (0...3).reversed() {

            run(SKAction.wait(forDuration: offset)) {
                self.countdownLabel.text = "\(x)"

                if x == 0 {
                    //do something when counter hits 0
                    //self.runGameOver()
                    if let countdownNode = self.pauseLayer.childNode(withName: "countdown") as? SKLabelNode {
                        countdownNode.removeFromParent()
                    }
                    self.unpauseGame()
                    
                }
                else {
                     //maybe play some sound tick file here
                }
            }
            offset += 1.0
        }
    }
    
    func checkGameOver() -> Bool {
        for player in players{
            if ( player.roundScore == 5 ){
                return true
            }
        }
        return false
    }
    
    func pauseGame() {

        gameLayer.isPaused = true
        pauseLayer.isHidden = false
        self.physicsWorld.speed = 0.0
        gameLayer.speed = 0.0

    }

    func unpauseGame() {

        gameLayer.isPaused = false
        pauseLayer.isHidden = true
        gameLayer.speed = 1.0
        self.physicsWorld.speed = 1.0
        // Whatever else you need to undo

    }
    
    // fire projectile in direction player tank is facing
    func fireProjectile(player: Player) {
        
        if ( player.ammo > 0 ) {
            let projectile:Projectile = Projectile(imageNamed: "defaultProjectile")
            projectile.owner = player
            let direction = CGPoint(x:player.position.x - sin(player.zRotation) * 2000,y:player.position.y + cos(player.zRotation) * 2000)
            let xDirection = player.position.x - sin(player.zRotation) + (-35 * sin(player.zRotation))
            let yDirection = player.position.y + cos(player.zRotation) + (35 * cos(player.zRotation))
            
            projectile.position = CGPoint(x: xDirection,y:yDirection)
            
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.shot
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.p1 | PhysicsCategory.p2 | PhysicsCategory.p3 | PhysicsCategory.p4 | PhysicsCategory.obstacle
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            
            gameLayer.addChild(projectile)
            
            let shoot = SKAction.move(to: direction, duration: 2.0)
            let shootDone = SKAction.removeFromParent()
            projectile.run(SKAction.sequence([shoot, shootDone]))
            
            player.ammo -= 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in:self)
            
            if ( !gameLayer.isPaused ) {
                for i in 1...numberOfPlayers {
                    if (leftButtons[i-1].contains(location)){
                        leftPressed[i-1] = true
                    }
                    
                    if (rightButtons[i-1].contains(location)){
                        fireProjectile(player: players[i-1])
    //                    players[i-1].fireProjectile()
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in:self)
            
            if ( !gameLayer.isPaused ) {
                for i in 1...numberOfPlayers {
                    if (leftButtons[i-1].contains(location)){
                        leftPressed[i-1] = true
                    } else{
                        leftPressed[i-1] = false
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in:self)
            
            if ( !gameLayer.isPaused ) {
                for i in 1...numberOfPlayers {
                    if (leftButtons[i-1].contains(location)){
                        leftPressed[i-1] = false
                    }
                    
                    if (rightButtons[i-1].contains(location)){
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // move tanks forward
        for player in players {
            player.drive(tankMoveSpeed: tankMoveSpeed)
        }
        
        // turn tanks
        for i in 1...numberOfPlayers {
            if (tankTurnDirection == "left") {
                if (leftPressed[i-1]){
                    players[i-1].zRotation += CGFloat(tankRotateSpeed)
                }
            } else {
                if (leftPressed[i-1]){
                    players[i-1].zRotation -= CGFloat(tankRotateSpeed)
                }
            }
                
        }
        
        boundsChecktanks()
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
    
    func drawPlayableArea(){
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.black
        shape.lineWidth = 4.0
        
        shape.physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        shape.physicsBody?.isDynamic = true
        shape.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        shape.physicsBody?.contactTestBitMask = PhysicsCategory.shot
        shape.physicsBody?.collisionBitMask = PhysicsCategory.p1 | PhysicsCategory.p2 | PhysicsCategory.p3 | PhysicsCategory.p4
        
        gameLayer.addChild(shape)
    }
    
    func projectileDidCollideWithTank(projectile: Projectile, player: Player) {
        if(projectile.owner == player){
            projectile.owner.gameScore -= 10
        } else {
            projectile.owner.gameScore += 10
            print(projectile.owner.gameScore)
        }
        
        projectile.removeFromParent()
        player.hit()
        
        if (checkRoundOver()){
            newRound()
        }
    }
    
//    func projectileDidCollideWithShield(projectile: SKSpriteNode, shield: SKShapeNode) {
//        print("Hit")
//        projectile.removeFromParent()
//        shield.removeFromParent()
//    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask == PhysicsCategory.p1) && (secondBody.categoryBitMask == PhysicsCategory.shot)) {
            if let player = firstBody.node as? Player, let projectile = secondBody.node as? Projectile {
                projectileDidCollideWithTank(projectile: projectile, player: player)
            }
        }
        
        if ((firstBody.categoryBitMask == PhysicsCategory.p2) && (secondBody.categoryBitMask == PhysicsCategory.shot)) {
            if let player = firstBody.node as? Player, let projectile = secondBody.node as? Projectile {
                projectileDidCollideWithTank(projectile: projectile, player: player)
            }
        }
        
        if ((firstBody.categoryBitMask == PhysicsCategory.p3) && (secondBody.categoryBitMask == PhysicsCategory.shot)) {
            if let player = firstBody.node as? Player, let projectile = secondBody.node as? Projectile {
                projectileDidCollideWithTank(projectile: projectile, player: player)
            }
        }
        
        if ((firstBody.categoryBitMask == PhysicsCategory.p4) && (secondBody.categoryBitMask == PhysicsCategory.shot)) {
            if let player = firstBody.node as? Player, let projectile = secondBody.node as? Projectile {
                projectileDidCollideWithTank(projectile: projectile, player: player)
            }
        }
        
//        if ((firstBody.categoryBitMask == PhysicsCategory.shot) && (secondBody.categoryBitMask == PhysicsCategory.shield)) {
//            if let projectile = firstBody.node as? SKSpriteNode, let shield = secondBody.node as? SKShapeNode {
//                projectileDidCollideWithShield(projectile: projectile, shield: shield)
//            }
//        }
    }
}
