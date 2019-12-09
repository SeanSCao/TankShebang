//
//  Start.swift
//  TankShebang
//
//  Created by Aryan Agarwal on 12/9/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import UIKit
import SpriteKit

class Start: SKScene {
    var startButton:SKSpriteNode!
    var optionsButton:SKSpriteNode!
    
    
    override func didMove(to view: SKView){

       }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          
               for touch in touches {
                   let location = touch.location(in: self)
                   let node : SKNode = self.atPoint(location)
                   if node.name == "Start" {
                    if let view = self.view {
                       
                        let reveal = SKTransition.reveal(with: .down, duration: 1)
                                        
                                          
                                          let Start = GameScene(size: self.size)
                        self.view?.presentScene(Start, transition: reveal)

                        let gameScene = GameScene(size: view.bounds.size)
                        view.presentScene(gameScene)
                        
                          }
                    
     } else if node.name == "Options" {
                    if let view = self.view {
                          //            // Load the SKScene from 'GameScene.sks'
                                      if let scene = SKScene(fileNamed: "Menu") {
                                          // Set the scale mode to scale to fit the window
                                          scene.scaleMode = .aspectFill
                          
                          //                // Present the scene
                                         view.presentScene(scene)
                          //            }
                              }
                          }
                    

                    
}
}

}
}
