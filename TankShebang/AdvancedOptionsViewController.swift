//
//  AdvancedOptionsViewController.swift
//  TankShebang
//
//  Created by Robert Beit on 12/9/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import UIKit

class AdvancedOptionsViewController: UIViewController {
    
    @IBOutlet weak var AutoBalanceButton: UIButton!
    
    @IBOutlet weak var PowerupsButton: UIButton!
    
    
    @IBOutlet weak var FixedSpawnButton: UIButton!
    
    @IBOutlet weak var ScatterShotButton: UIButton!
    var auto = "On"
    var power = "On"
    var spawn = "On"
    var scatter = "On"
    
    @IBAction func TouchAutoBalance(_ sender: Any) {
        if(auto == "Off"){
            auto = "On"
        }
        else if(auto == "On"){
            auto = "Off"
        }
        AutoBalanceButton.setTitle(auto, for: .normal)
    }
    
    
    @IBAction func TouchPowerups(_ sender: Any) {
        if(power == "Off"){
            power = "On"
        }
        else if(power == "On"){
            power = "Off"
        }
        PowerupsButton.setTitle(power, for: .normal)
    }
    
    @IBAction func TouchFixedSpawn(_ sender: Any) {
        if(spawn == "Off"){
            spawn = "On"
        }
        else if(spawn == "On"){
            spawn = "Off"
        }
        FixedSpawnButton.setTitle(spawn, for: .normal)
    }
    
    @IBAction func TouchScatterShot(_ sender: Any) {
        if(scatter == "On"){
            scatter = "Off"
        }
        else if(scatter == "Off"){
            scatter = "On"
        }
        ScatterShotButton.setTitle(scatter, for: .normal)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var game_options = segue.destination as! GameOptionsViewController
        game_options.AutoBalance = auto
        game_options.Powerups = power
        game_options.FixedSpawn = spawn
        game_options.ScatterShot = scatter
        
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
