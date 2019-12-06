//
//  Options.swift
//  TankShebang
//
//  Created by Aryan Agarwal on 11/29/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import SpriteKit
class Options: SKScene {
    var TerrButton:SKSpriteNode!
    var PowerButton:SKSpriteNode!
    var SubmitButton:SKSpriteNode!
    
    
    override func didMove(to view: SKView){

    //    TerrButton = self.childNode(withName: "1") as! SKSpriteNode
          
  //      PowerButton = self.childNode(withName: "2") as! SKSpriteNode
          
   //   SubmitButton = self.childNode(withName: "3") as! SKSpriteNode
          
     //  TerrButton.texture = SKTexture(imageNamed: "Terrain")
   
    //    PowerButton.texture = SKTexture(imageNamed: "POWERUP")

    //   SubmitButton.texture = SKTexture(imageNamed: "Submit")
               
          
          
      }
      
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in:self){
            
            let nodeArray = self.nodes(at: location)
            
            if nodeArray.first?.name == "1" {
                
             
                
                
            } else if nodeArray.first?.name == "2" {
             
            } else if nodeArray.first?.name == "3" {
                        
                       }
                       
            
            
          
        }
    }
    
    
    
}
