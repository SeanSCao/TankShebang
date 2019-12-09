//
//  GameViewController.swift
//  TankShebang
//
//  Created by Sean Cao on 11/5/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var Mode = String()
    var Level = String()
    var Kill = String()
    var sound = String()
    var music = String()
    var AutoBalance = String()
    var Powerups = String()
    var FixedSpawn = String()
    var ScatterShot = String()
    var num_players = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let scene = Menu(size: view.bounds.size)
            //scene.mode = Mode
        //scene.level = Level
        //scene.kill = Kill
        //scene.sound = sound
        //scene.music = music
        //scene.AutoBalance = AutoBalance
        //scene.Powerups = Powerups
        //scene.FixedSpawn = FixedSpawn
        //scene.ScatterShot = ScatterShot
        //scene.num_players = num_players
    //    let skView = view as! SKView
      //  skView.showsFPS = true
        //skView.showsNodeCount = true
        //skView.ignoresSiblingOrder = true
        //scene.scaleMode = .resizeFill
        //skView.presentScene(scene)
        if let view = self.view as! SKView? {
        if let scene = SKScene(fileNamed: "Menu") {
            scene.scaleMode = .aspectFit
            
            view.presentScene(scene)
        }
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
    }
    }

//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

