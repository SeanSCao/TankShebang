//
//  Menu.swift
//  TankShebang
//
//  Created by Aryan Agarwal on 11/29/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import SpriteKit
class Menu: SKScene {
    var startButton:SKSpriteNode!
    var optionsButton:SKSpriteNode!
    
    override func didMove(to view: SKView){
        
        startButton = self.childNode(withName: "Start") as! SKSpriteNode
        
        
        
        
        optionsButton = self.childNode(withName: "Options") as! SKSpriteNode
        
        
        optionsButton.texture = SKTexture(imageNamed: "Options")
        
        startButton.texture = SKTexture(imageNamed: "Start")
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in:self){
            
            let nodeArray = self.nodes(at: location)
            
            if nodeArray.first?.name == "Start" {
                
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
                
                
            }
        }
    }
    
    
}
