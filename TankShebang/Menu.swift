//
//  Menu.swift
//  TankShebang
//
//  Created by Aryan Agarwal on 11/29/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import SpriteKit
import AVFoundation
class Menu: SKScene {
    var startButton:SKSpriteNode!
    var optionsButton:SKSpriteNode!
    var TerrainButton:SKSpriteNode!
    var PowerUpButton:SKSpriteNode!
    var SoundButton:SKSpriteNode!
    var counter: Int = 0
    var counter2: Int = 0
    var counter3: Int = 0
    var player: AVAudioPlayer?

    override func didMove(to view: SKView){
        playSound()

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
            for touch in touches {
                let location = touch.location(in: self)
                let node : SKNode = self.atPoint(location)
                if node.name == "Terrain" {
                    if let label = self.childNode(withName: "Style") as? SKLabelNode {
                    if counter % 2 == 0 {
                        label.text = "Ice"
                            counter+=1
                        } else {
                                                      label.text = "Rock"
                                counter+=1

                        }
                       
                        
                    
                    
                    }
                
                } else if node.name == "Start" {
                   // let label = self.childNode(withName: "Style") as? SKLabelNode
                    let reveal = SKTransition.reveal(with: .down, duration: 1)
                  
                    
                    let Start = GameScene(size: self.size)
                    let label = self.childNode(withName: "Style") as? SKLabelNode
                    let label2 = self.childNode(withName: "PowerLabel") as? SKLabelNode
                    let label3 = self.childNode(withName: "Label2") as? SKLabelNode


                    if( label!.text == nil){
                        label!.text = "Ice"
                    }
                    if( label2!.text == nil){
                        label!.text = "On"
                    }
                    if( label3!.text == nil){
                        label!.text = "On"
                    }


                    Start.TerrainType = label!.text!
                    Start.PowerupType = label2!.text!
                    Start.SoundType = label3!.text!
                    self.view?.presentScene(Start, transition: reveal)

                    let gameScene = GameScene(size: view!.bounds.size)
                                   view!.presentScene(gameScene)

                    
                    } else if node.name == "Sound" {
                    playSound()
                    if let label2 = self.childNode(withName: "Label2") as? SKLabelNode {
                        if counter2 % 2 == 0 {
                        label2.text = "On"
                            playSound()

                            counter2+=1
                        } else {
                                                      label2.text = "Off"
                            playSound()

                                counter2+=1

                        }
                        
                    } } else if node.name == "Powerup" {
                        
                        if let label3 = self.childNode(withName: "PowerLabel") as? SKLabelNode {
                            if counter3 % 2 == 0 {
                            label3.text = "On"
                                counter3+=1
                            } else {
                                                          label3.text = "Off"
                                    counter3+=1

                            }
                }
                
            }
       
        

        
        
        
        
        
        
        
        
      //  let touch = touches.first
        
     //   if let location = touch?.location(in:self){
            
       //     let nodeArray = self.nodes(at: location)
            
         //   if nodeArray.first?.name == "Start" {
                
          //      let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                
              //  let gameScene = GameScene(size: self.size)
              //  self.view?.presentScene(gameScene, transition: transition)
                
                
        //    } else if nodeArray.first?.name == "Options" {
          //      let transition2 = SKTransition.flipHorizontal(withDuration: 0.5)
                               
               //               let gameScene2 = Options(size: self.size)
                 //              self.view?.presentScene(gameScene2, transition: transition2)
          //  }
            
            
          
      //  }
    }
    
    


}

     func playSound() {
            guard let url = Bundle.main.url(forResource: "Music", withExtension: "mp3") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

                /* iOS 10 and earlier require the following line:
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

                guard let player = player else { return }

                player.play()

            } catch let error {
                print(error.localizedDescription)
            }
        
    
}

}
