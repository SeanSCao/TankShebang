//  GameScene.swift
//  TankShebang
//
//  Created by Sean Cao on 11/5/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let none                 : UInt32 = 0
    static let all                  : UInt32 = UInt32.max
    static let player               : UInt32 = 0b1
    static let obstacle             : UInt32 = 0b10
    static let projectile           : UInt32 = 0b11
    static let shield               : UInt32 = 0b100
    static let laser                : UInt32 = 0b101
    static let explosion            : UInt32 = 0b110
    static let pickupTile           : UInt32 = 0b111
    static let landmine             : UInt32 = 0b1000
}

class GameScene: SKScene {
    var viewController: UIViewController?
    
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
    
    var players = [Player]()
    let playerColors = ["Black", "Red", "Blue", "Green"]
    let colorsDict:[String:SKColor] = ["Black":SKColor.black, "Red": SKColor(red: 194/255.0, green: 39/255.0, blue: 14/255.0, alpha: 1), "Blue":SKColor(red: 13/255.0, green: 80/255.0, blue: 194/255.0, alpha: 1), "Green":SKColor(red: 90/255.0, green: 194/255.0, blue: 15/255.0, alpha: 1)]
    
    var rightButtons = [SKShapeNode]()
    var leftButtons = [SKShapeNode]()
    var leftPressed = [false, false, false, false]
    
    let tankMoveSpeed = CGFloat(3) //tank driving speed
    var tankTurnLeft = true //tank turning direction
    var tankDriveForward = true // tank driving direction
    let tankRotateSpeed = 0.1 //tank turning speed
    
    var countdownLabel: SKLabelNode!
    var restartButton = SKSpriteNode()
    var menuButton = SKSpriteNode()
    
    let backgroundSound = SKAudioNode(fileNamed: "background.mp3")
    
    var isPausedFix = true
    
    var mapSetting = 2
    var numberOfPlayers = 4
    var startWithShield = false
    var SFX = true
    var MUSIC = true
    var POWERUPS = true
    var STARTPOWERUPS = true
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        
        pauseLayer.zPosition = 200
        
        addChild(gameLayer)
        
        addChild(pauseLayer)
        
        initMap()
        
        initPlayers()
        
        initButtons()
        
        drawPlayableArea()
        
        self.gameLayer.isPaused = true
        
        countdown(length:3)
        
        if (POWERUPS){
            gameLayer.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 3.0), SKAction.run(spawnPowerTile)])))
        }
        
        if (self.MUSIC){
            gameLayer.addChild(backgroundSound)
            self.backgroundSound.run(SKAction.changeVolume(to: Float(0.5), duration: 0))
            self.backgroundSound.run(SKAction.stop())
        }
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
    }
    
    // create sprite node for each player tank and position accordingly
    func initPlayers(){
        let gameScale = size.width / 1024
        
        for i in 1...numberOfPlayers {
            let spriteFile = playerColors[i-1] + "4"
            let player:Player = Player(imageNamed: spriteFile) //player tank
            player.SFX = self.SFX
            player.name = "Player " + String(i)
            player.colorString = playerColors[i-1]
            player.zPosition = 100
            
            player.gameScale = gameScale
            player.setScale(0.6*gameScale)
            
            player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
            player.physicsBody?.isDynamic = true
            player.physicsBody?.restitution = 1.0
            
            if(i==1) {
                player.physicsBody?.categoryBitMask = PhysicsCategory.player
                player.physicsBody?.contactTestBitMask = PhysicsCategory.projectile | PhysicsCategory.laser
                player.physicsBody?.collisionBitMask = PhysicsCategory.obstacle | PhysicsCategory.player
            } else if(i==2) {
                player.physicsBody?.categoryBitMask = PhysicsCategory.player
                player.physicsBody?.contactTestBitMask = PhysicsCategory.projectile | PhysicsCategory.laser
                player.physicsBody?.collisionBitMask = PhysicsCategory.obstacle | PhysicsCategory.player
            } else if(i==3) {
                player.physicsBody?.categoryBitMask = PhysicsCategory.player
                player.physicsBody?.contactTestBitMask = PhysicsCategory.projectile | PhysicsCategory.laser
                player.physicsBody?.collisionBitMask = PhysicsCategory.obstacle | PhysicsCategory.player
            } else {
                player.physicsBody?.categoryBitMask = PhysicsCategory.player
                player.physicsBody?.contactTestBitMask = PhysicsCategory.projectile | PhysicsCategory.laser
                player.physicsBody?.collisionBitMask = PhysicsCategory.obstacle | PhysicsCategory.player
            }
            players.append(player)
        }
        resetTanks()
        for player in players {
            Timer.scheduledTimer(timeInterval: 1, target: player, selector: #selector(player.reload), userInfo: nil, repeats: true)
        }
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
            let spriteFile:String = players[i-1].colorString + "4"
            players[i-1].texture = SKTexture(imageNamed: spriteFile)
            if (startWithShield ) {
                players[i-1].addShield()
            } else {
                players[i-1].removeShield()
            }
            let powerups = ["Rocket", "Laser", "Landmine", "Bubble"]
            if (self.STARTPOWERUPS) {
                players[i-1].powerup = powerups[Int.random(in:1...3)]
            } else {
                players[i-1].powerup = ""
            }
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
                    playerLeft.fillColor = colorsDict[playerColors[i-1]]!
                    playerRight.fillColor = colorsDict[playerColors[i-1]]!
                    playerLeft.position = CGPoint(x:0, y:0)
                    playerRight.position = CGPoint(x:size.width, y:0)
                    playerRight.zRotation += .pi/2
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                } else if (i==2){
                    // player 2 button positioning
                    playerLeft.fillColor = colorsDict[playerColors[i-1]]!
                    playerRight.fillColor = colorsDict[playerColors[i-1]]!
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
                    playerLeft.fillColor = colorsDict[playerColors[i-1]]!
                    playerRight.fillColor = colorsDict[playerColors[i-1]]!
                    playerLeft.position = CGPoint(x:0, y:0)
                    playerRight.position = CGPoint(x:size.width, y:0)
                    playerRight.zRotation += .pi/2
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                } else if (i==2) {
                    // player 2 button positioning
                    playerLeft = createSmallLeftTriangle()
                    playerRight = createSmallRightTriangle()
                    playerLeft.fillColor = colorsDict[playerColors[i-1]]!
                    playerRight.fillColor = colorsDict[playerColors[i-1]]!
                    playerLeft.position = CGPoint(x:0, y:size.height)
                    playerRight.position = CGPoint(x:0, y:size.height)
                    playerLeft.zRotation += .pi * 3/2
                    playerRight.zRotation += .pi * 3/2
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                } else {
                    playerLeft = createSmallLeftTriangle()
                    playerRight = createSmallRightTriangle()
                    playerLeft.fillColor = colorsDict[playerColors[i-1]]!
                    playerRight.fillColor = colorsDict[playerColors[i-1]]!
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
                    playerLeft.fillColor = colorsDict[playerColors[i-1]]!
                    playerRight.fillColor = colorsDict[playerColors[i-1]]!
                    playerLeft.position = CGPoint(x:0, y:0)
                    playerRight.position = CGPoint(x:0, y:0)
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                } else if (i==2) {
                    // player 2 button positioning
                    playerLeft.fillColor = colorsDict[playerColors[i-1]]!
                    playerRight.fillColor = colorsDict[playerColors[i-1]]!
                    playerLeft.position = CGPoint(x:size.width, y:0)
                    playerRight.position = CGPoint(x:size.width, y:0)
                    playerLeft.zRotation += .pi * 1/2
                    playerRight.zRotation += .pi * 1/2
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                } else if (i==3){
                    playerLeft.fillColor = colorsDict[playerColors[i-1]]!
                    playerRight.fillColor = colorsDict[playerColors[i-1]]!
                    playerLeft.position = CGPoint(x:size.width, y:size.height)
                    playerRight.position = CGPoint(x:size.width, y:size.height)
                    playerLeft.zRotation += .pi
                    playerRight.zRotation += .pi
                    
                    playerRight.alpha = 0.6
                    playerLeft.alpha = 0.6
                } else {
                    playerLeft.fillColor = colorsDict[playerColors[i-1]]!
                    playerRight.fillColor = colorsDict[playerColors[i-1]]!
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
        let playableHeight = size.width
        let playableMargin = (size.height-playableHeight)/2.0
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
        } else if (mapSetting == 2) {
            let dirtTiles = tileSet.tileGroups.first { $0.name == "Dirt"}
            bottomLayer.fill(with: dirtTiles)
        } else {
            let dirtTiles = tileSet.tileGroups.first { $0.name == "Dirt"}
            bottomLayer.fill(with: dirtTiles)
        }
        
        map.addChild(bottomLayer)
        
        if (mapSetting==1){
            
        } else {
            for _ in 1...25 {
                let rock = SKSpriteNode(imageNamed: "Rock")
                rock.name = "obstacle"
                rock.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
                rock.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
                rock.physicsBody?.collisionBitMask = PhysicsCategory.player | PhysicsCategory.pickupTile
                rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
                rock.physicsBody?.isDynamic = false
                
                let randX = Int.random(in: 100...Int(size.width-100))
                let randY = Int.random(in: Int(playableMargin)+100...Int(playableMargin)+Int(size.width)-100)
                rock.position = CGPoint(x:CGFloat(randX),y:CGFloat(randY))
                rock.setScale(0.3)
                gameLayer.addChild(rock)
            }
        }
    }
    
    func spawnPowerTile() {
        let tilesArr = ["Direction", "LandmineTile", "LaserTile", "Reverse", "RocketTile", "ShieldTile", "BubbleTile"]
        let gameScale = 0.3 * size.width / 1024
        let playableMargin = (size.height-size.width)/2.0
        let playableHeight = playableMargin + size.width
        let randTile = Int.random(in: 0...tilesArr.count-1)
        let randX = Int.random(in: 0...Int(size.width))
        let randY = Int.random(in: Int(playableMargin)...Int(playableHeight))
        
        let tile = SKSpriteNode(imageNamed: tilesArr[randTile])
        tile.setScale(gameScale)
        tile.name = tilesArr[randTile]
        tile.position = CGPoint(x: randX, y: randY)
        tile.physicsBody?.contactTestBitMask = PhysicsCategory.player
        tile.physicsBody?.collisionBitMask = PhysicsCategory.obstacle
        
        tile.physicsBody = SKPhysicsBody(circleOfRadius: tile.size.height/2)
        tile.physicsBody?.isDynamic = false
        tile.physicsBody?.categoryBitMask = PhysicsCategory.pickupTile
        
        
        gameLayer.addChild(tile)
        
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
        
        gameLayer.removeAllActions()
        for player in players{
            player.removeAllActions()
        }
        
        if ( !checkGameOver() ) {
            run(SKAction.wait(forDuration: 1)){
                self.initScoreboard()
                self.removeElements()
                self.leftPressed = [false, false, false, false]
                self.resetTanks()
                self.changeMap()
                self.countdown(length:5)
                self.tankTurnLeft = true
                self.tankDriveForward = true
            }
            
        } else {
            gameOver()
        }
    }
    
    func gameOver() {
        self.backgroundSound.run(SKAction.stop())
        gameLayer.removeAllActions()
        for player in players{
            player.removeAllActions()
        }
        run(SKAction.wait(forDuration: 1)){
            self.backgroundSound.run(SKAction.stop())
            var winner:Player = self.players[0]
            for player in self.players{
                if ( player.gameScore > winner.gameScore ){
                    winner = player
                }
            }
            self.initScoreboard()
            self.removeElements()
            self.leftPressed = [false, false, false, false]
            self.pauseGame()
            self.countdownLabel = SKLabelNode(fontNamed: "Avenir")
            self.countdownLabel.name = "winner"
            self.countdownLabel.text = winner.name! + " Wins"
            self.countdownLabel.horizontalAlignmentMode = .center
            self.countdownLabel.position = CGPoint(x:self.size.width/2, y:self.size.height/2-45)
            self.pauseLayer.addChild(self.countdownLabel)
            
            if let button = self.pauseLayer.childNode(withName: "restart") as? SKSpriteNode {
                button.removeFromParent()
            }
            if let button = self.pauseLayer.childNode(withName: "menu") as? SKSpriteNode {
                button.removeFromParent()
            }
            self.restartButton = SKSpriteNode(imageNamed: "Restart")
            self.restartButton.position = CGPoint(x:self.size.width/2-50, y:self.size.height/3)
            self.restartButton.setScale(0.25)
            self.restartButton.name = "restart"
            self.pauseLayer.addChild(self.restartButton)
            self.menuButton = SKSpriteNode(imageNamed: "Menu")
            self.menuButton.position = CGPoint(x:self.size.width/2+50, y:self.size.height/3)
            self.menuButton.setScale(0.25)
            self.menuButton.name = "menu"
            self.pauseLayer.addChild(self.menuButton)
            winner.removeFromParent()
            
            if (self.SFX) {
                let sound = SKAudioNode(fileNamed: "gameover.mp3")
                sound.autoplayLooped = false
                self.addChild(sound)
                self.run(SKAction.run {
                    sound.run(SKAction.play())
                    self.backgroundSound.run(SKAction.stop())
                })
            }
        }
    }
    
    func resetGame() {
        players.removeAll()
        initPlayers()
        for player in players{
            player.gameScore = 0
            player.roundScore = 0
        }
        for child in self.pauseLayer.children {
            if (child.name=="scoreboard"){
                child.removeFromParent()
            }
            if (child.name=="menu"){
                child.removeFromParent()
            }
            if (child.name=="restart"){
                child.removeFromParent()
            }
            if (child.name=="winner"){
                child.removeFromParent()
            }
        }
        self.tankTurnLeft = true
        self.tankDriveForward = true
        self.unpauseGame()
        self.removeElements()
        self.leftPressed = [false, false, false, false]
//        self.resetTanks()
        self.changeMap()
        self.countdown(length:3)
    }
    
    func initScoreboard(){
        for i in 1 ... numberOfPlayers {
            let box = SKShapeNode()
            box.name = "scoreboard"
            box.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 128, height: 128), cornerRadius: 16).cgPath
            let xPosition = CGFloat(CGFloat(i) * size.width / CGFloat(numberOfPlayers+1) - 64)
            box.position = CGPoint(x: xPosition, y: frame.midY)
            box.fillColor = colorsDict[playerColors[i-1]] ?? SKColor.white
            box.strokeColor = SKColor.black
            box.lineWidth = 1
            pauseLayer.addChild(box)
            
            let tankFile = playerColors[i-1] + "0"
            let tank = SKSpriteNode(imageNamed: tankFile)
            tank.setScale(0.4)
            tank.position = CGPoint(x:64, y:90)
            tank.zPosition = 101
            box.addChild(tank)
            
            let scoreLabel = SKLabelNode(fontNamed: "Avenir")
            scoreLabel.name = "score"
            scoreLabel.horizontalAlignmentMode = .center
            scoreLabel.position = CGPoint(x:64, y:10)
            scoreLabel.text = String(players[i-1].gameScore)
            box.addChild(scoreLabel)
        }
    }
    
    func removeElements(){
        for child in gameLayer.children{
            if let projectile = child as? Projectile {
                projectile.removeFromParent()
            }
            if child.physicsBody?.categoryBitMask == PhysicsCategory.pickupTile{
                child.removeFromParent()
            }
            if child.name == "obstacle" {
                child.removeFromParent()
            }
        }
    }
    
    func countdown(length:Int) {
        countdownLabel = SKLabelNode(fontNamed: "Avenir")
        countdownLabel.name = "countdown"
        countdownLabel.horizontalAlignmentMode = .center
        countdownLabel.position = CGPoint(x:size.width/2, y:size.height/2-45)
        pauseLayer.addChild(countdownLabel)
        
        self.pauseGame()
        
        var offset: Double = 0
        
        for x in (0...length).reversed() {
            
            run(SKAction.wait(forDuration: offset)) {
                self.countdownLabel.text = "New Round In: \(x)"
                
                if x == 0 {
                    if let countdownNode = self.pauseLayer.childNode(withName: "countdown") as? SKLabelNode {
                        countdownNode.removeFromParent()
                    }
                    for child in self.pauseLayer.children{
                        if child.name == "scoreboard" {
                            child.removeFromParent()
                        }
                    }
                    self.unpauseGame()
                }
                else {
                    if (self.SFX){
                        let sound = SKAudioNode(fileNamed: "menu.mp3")
                        sound.autoplayLooped = false
                        self.addChild(sound)
                        self.run(SKAction.run {sound.run(SKAction.play())})
                    }
                }
            }
            offset += 1.0
        }
    }
    
    func checkGameOver() -> Bool {
        for player in players{
            if ( player.gameScore > 200 ){
                return true
            }
        }
        return false
    }
    
    func pauseGame() {
        self.backgroundSound.run(SKAction.pause())
        gameLayer.isPaused = true
        pauseLayer.isHidden = false
        self.physicsWorld.speed = 0.0
        gameLayer.speed = 0.0
        self.isPausedFix = true
    }
    
    func unpauseGame() {
        self.backgroundSound.run(SKAction.play())
        gameLayer.isPaused = false
        pauseLayer.isHidden = true
        gameLayer.speed = 1.0
        self.physicsWorld.speed = 1.0
        self.isPausedFix = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in:self)
            
            if ( !self.isPausedFix ) {
                for i in 1...numberOfPlayers {
                    if (leftButtons[i-1].contains(location)){
                        leftPressed[i-1] = true
                    }
                    
                    if (rightButtons[i-1].contains(location)){
                        players[i-1].fireProjectile()
                    }
                }
            }
            if(!pauseLayer.isHidden){
                if (restartButton.contains(location)){
                    resetGame()
                }
                if (menuButton.contains(location)){
                    self.viewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in:self)
            
            if ( !self.isPausedFix ) {
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
        if (self.isPausedFix == false){
            for player in players {
                player.drive(tankDriveForward: tankDriveForward, tankMoveSpeed: tankMoveSpeed)
            }
        } else {
            for player in players {
                player.removeAllActions()
            }
        }
        
        // turn tanks
        for i in 1...numberOfPlayers {
            if (tankTurnLeft) {
                if (leftPressed[i-1]){
                    players[i-1].zRotation += CGFloat(tankRotateSpeed)
                }
            } else {
                if (leftPressed[i-1]){
                    players[i-1].zRotation -= CGFloat(tankRotateSpeed)
                }
            }
        }
        
        for child in gameLayer.children{
            if child.physicsBody?.categoryBitMask == PhysicsCategory.pickupTile{
                if (tankTurnLeft) {
                    child.zRotation += 0.03
                } else {
                    child.zRotation -= 0.03
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
        shape.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        shape.physicsBody?.collisionBitMask = PhysicsCategory.player
        
        gameLayer.addChild(shape)
    }
    
    func projectileDidCollideWithTank(projectile: Projectile, player: Player) {
        
        player.hit(projectile: projectile)
        
        if (checkRoundOver()){
            newRound()
        }
    }
    
    func explosionDidCollideWithTank(explosion: Projectile, player: Player) {
        player.explode(explosion: explosion)

        if (checkRoundOver()){
            newRound()
        }
    }
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
        
        if ((firstBody.categoryBitMask == PhysicsCategory.player) && (secondBody.categoryBitMask == PhysicsCategory.projectile)) {
            if let player = firstBody.node as? Player, let projectile = secondBody.node as? Projectile {
                projectileDidCollideWithTank(projectile: projectile, player: player)
            }
        }
        
        if ((firstBody.categoryBitMask == PhysicsCategory.player) && (secondBody.categoryBitMask == PhysicsCategory.laser)) {
            if let player = firstBody.node as? Player, let projectile = secondBody.node as? Projectile {
                projectileDidCollideWithTank(projectile: projectile, player: player)
            }
        }
        
        if ((firstBody.categoryBitMask == PhysicsCategory.player) && (secondBody.categoryBitMask == PhysicsCategory.landmine)) {
            if let player = firstBody.node as? Player, let mine = secondBody.node as? Projectile {
                if (mine.owner != player){
                    mine.activateMine()
                }
            }
        }
        
        if ((firstBody.categoryBitMask == PhysicsCategory.player) && (secondBody.categoryBitMask == PhysicsCategory.explosion)) {
            if let player = firstBody.node as? Player, let explosion = secondBody.node as? Projectile {
                explosionDidCollideWithTank(explosion: explosion, player: player)
            }
        }
        
        if ((firstBody.categoryBitMask == PhysicsCategory.player) && (secondBody.categoryBitMask == PhysicsCategory.pickupTile)) {
            if let player = firstBody.node as? Player, let pickupTile = secondBody.node as? SKSpriteNode {
                if (pickupTile.name == "Direction" ) {
                    tankDriveForward = !tankDriveForward
                    if (self.SFX) {
                        let sound = SKAudioNode(fileNamed: "reverse.mp3")
                        sound.autoplayLooped = false
                        self.addChild(sound)
                        self.run(SKAction.run {sound.run(SKAction.play())})
                    }
                    
                } else if (pickupTile.name == "Reverse" ) {
                    if (self.SFX) {
                        let sound = SKAudioNode(fileNamed: "reverse.mp3")
                        sound.autoplayLooped = false
                        self.addChild(sound)
                        self.run(SKAction.run {sound.run(SKAction.play())})
                    }
                    tankTurnLeft = !tankTurnLeft
                } else if (pickupTile.name == "ShieldTile") {
                    player.addShield()
                }
                else {
                    let powerUpString = String(pickupTile.name?.dropLast(4) ?? "")
                    player.powerup = powerUpString
                }
                pickupTile.removeFromParent()
                
            }
        }
        
        if ((firstBody.categoryBitMask == PhysicsCategory.obstacle) && (secondBody.categoryBitMask == PhysicsCategory.projectile)) {
            if let projectile = secondBody.node as? Projectile {
                if (projectile.name=="Rocket"){
                    projectile.activateRocket()
                } else {
                    projectile.removeFromParent()
                }
            }
        }
    }
}
