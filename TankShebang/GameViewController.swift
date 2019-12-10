import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var Mode = String()
    var Terrain = String()
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
        
        let scene = GameScene(size: view.bounds.size)
        if(FixedSpawn == "On"){
            scene.startWithShield = true
        }
        else{
            scene.startWithShield = false
        }
        if(ScatterShot == "On"){
            scene.STARTPOWERUPS = true
        }
        else{
           scene.STARTPOWERUPS = false
        }
        if(Powerups == "On"){
            scene.POWERUPS = true
        }
        else{
            scene.POWERUPS = false

            
        }
        if(music == "On"){
            scene.MUSIC = true
        }
        if (music == "Off"){
            scene.MUSIC = false
        }
        if(sound == "On"){
           scene.SFX = true
        }
        else{
           scene.SFX = false
        }
        if(Terrain  == "Grass"){
            scene.mapSetting = 1
        }
        else{
            scene.mapSetting = 2
            
        }
        scene.viewController = self
        
        scene.numberOfPlayers = num_players
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
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
