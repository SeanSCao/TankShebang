//
//  GameOptionsViewController.swift
//  TankShebang
//
//  Created by Robert Beit on 12/1/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import UIKit

class GameOptionsViewController: UIViewController {

    @IBOutlet weak var Level: UIButton!
    @IBOutlet weak var KillLength: UIButton!
    @IBOutlet weak var GameMode: UIButton!
    let modes = ["Tank Hunter","Pilot Hunter","Deathmatch"]
    var sound = String()
    var music = String()
    let kills = ["1","3","5"]
    let levels = ["Open Space","Moon","Dance"]
    var mode_start = 0
    var kill_start = 0
    var level_start = 0
    var level = "Open Space"
    var kill = "3"
    var mode = "Tank Hunter"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchlevel(_ sender: Any) {
        level_start += 1
        if(level_start > 2){
            level_start = 0
        }
        Level.setTitle(levels[level_start], for: .normal)
        level = levels[level_start]
    }
    
    @IBAction func touchKillLength(_ sender: Any) {
        kill_start += 1
        if(kill_start > 2){
            kill_start = 0
        }
        KillLength.setTitle(kills[kill_start], for: .normal)
        kill = kills[kill_start]
    }
    
    @IBAction func touchGameMode(_ sender: Any) {
        mode_start += 1
        if(mode_start > 2){
            mode_start = 0
        }
        GameMode.setTitle(modes[mode_start], for: .normal)
        mode = modes[mode_start]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Game"){
            var game_view = segue.destination as! GameViewController
            game_view.Mode = mode
            game_view.Level = level
            game_view.Kill = kill
            
        }
        
        
        
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
