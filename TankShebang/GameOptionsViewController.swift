//
//  GameOptionsViewController.swift
//  TankShebang
//
//  Created by Robert Beit on 12/9/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import UIKit

class GameOptionsViewController: UIViewController {
    var num_players = 2
    var Music = String()
    var Sound = String()
    var AutoBalance = String()
    var Powerups = String()
    var FixedSpawn = String()
    var ScatterShot = String()
    let modes = ["Tank Hunter","Pilot Hunter","Deathmatch"]
    let kills = ["1","3","5"]
    let terrains = ["Dirt","Grass"]
    var mode_start = 0
    var kill_start = 0
    var level_start = 0
    var terrain = "Ice"
    var kill = "3"
    var mode = "Tank Hunter"

    @IBOutlet weak var ModeButton: UIButton!
    
    @IBOutlet weak var KillButton: UIButton!
    
    @IBOutlet weak var TerrainButton: UIButton!
    
    

    @IBAction func touchmode(_ sender: Any) {
        mode_start += 1
        if(mode_start > 2){
            mode_start = 0
        }
        ModeButton.setTitle(modes[mode_start], for: .normal)
        mode = modes[mode_start]

    }
    
    @IBAction func touchkill(_ sender: Any) {
        kill_start += 1
        if(kill_start > 2){
            kill_start = 0
        }
        KillButton.setTitle(kills[kill_start], for: .normal)
        kill = kills[kill_start]
    }
    
    @IBAction func touchterrain(_ sender: Any) {
        level_start += 1
        if(level_start > 1){
            level_start = 0
        }
        TerrainButton.setTitle(terrains[level_start], for: .normal)
        terrain = terrains[level_start]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Game"){
            let game_view = segue.destination as! GameViewController
            game_view.Mode = mode
            game_view.Terrain = terrain
            game_view.Kill = kill
            game_view.num_players = num_players
            game_view.music = Music
            game_view.sound = Sound
            game_view.AutoBalance = AutoBalance
            game_view.Powerups = Powerups
            game_view.FixedSpawn = FixedSpawn
            game_view.ScatterShot = ScatterShot
            
        }
        
    }
   

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
