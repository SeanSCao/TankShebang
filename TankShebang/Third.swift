//
//  Third.swift
//  TankShebang
//
//  Created by Aryan Agarwal on 11/29/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import SpriteKit



class Third: SKScene {
    var TerrainButtonNode:SKSpriteNode!
    var PowerUpButtonNode:SKSpriteNode!
    
 override func didMove(to view: SKView){
        TerrainButtonNode = self.childNode(withName: "TerrainButton") as! SKSpriteNode
           PowerUpButtonNode = self.childNode(withName: "PowerUpButton") as! SKSpriteNode

           TerrainButtonNode.texture = SKTexture(imageNamed: "Terrain")
           PowerUpButtonNode.texture = SKTexture(imageNamed: "POWERUP")

           
        
        
    }
    
    
    
}

