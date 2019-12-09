//
//  AdvancedOptionsViewController.swift
//  TankShebang
//
//  Created by Robert Beit on 12/3/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import UIKit

class AdvancedOptionsViewController: UIViewController {
    var auto = "On"
    var power = "On"
    var spawn = "On"
    var scatter = "On"

    @IBOutlet weak var Autobalance: UIButton!
    
    @IBOutlet weak var Powerups: UIButton!
    
    @IBOutlet weak var Fixedspawn: UIButton!
    
    @IBOutlet weak var Scattershot: UIButton!
    
    
    @IBAction func autobalance(_ sender: Any) {
        if(auto == "Off"){
            auto = "On"
        }
        if(auto == "On"){
            auto = "Off"
        }
        Autobalance.setTitle(auto, for: .normal)
        
    }
    
    
    @IBAction func powerups(_ sender: Any) {
        if(power == "Off"){
            power = "On"
        }
        if(power == "On"){
            power = "Off"
        }
        Powerups.setTitle(power, for: .normal)
    }
    
    @IBAction func fixedspawn(_ sender: Any) {
        if(spawn == "Off"){
            spawn = "On"
        }
        if(spawn == "On"){
            spawn = "Off"
        }
        Fixedspawn.setTitle(spawn, for: .normal)
    }
    
    @IBAction func scattershot(_ sender: Any) {
        if(scatter == "On"){
           scatter = "Off"
        }
        if(scatter == "Off"){
            scatter = "On"
        }
        Scattershot.setTitle(scatter, for: .normal)
        
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
