//
//  PlayerSelectViewController.swift
//  TankShebang
//
//  Created by Robert Beit on 12/9/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import UIKit

class PlayerSelectViewController: UIViewController {

    
    @IBOutlet weak var tank1: UIImageView!
    
    
    @IBOutlet weak var tank2: UIImageView!
    
    @IBOutlet weak var tank3: UIImageView!
    
    
    @IBOutlet weak var tank4: UIImageView!
    
    @IBOutlet weak var player1: UIButton!
    
    @IBOutlet weak var player2: UIButton!
    
    @IBOutlet weak var player3: UIButton!
    
    @IBOutlet weak var player4: UIButton!
    var player1status = "Off"
    var player2status = "Off"
    var player3status = "Off"
    var player4status = "Off"
    var num_players = 0
    var Music = String()
    var Sound = String()
    
    @IBAction func touchplayer1(_ sender: Any) {
        if(player1status == "Off"){
            
            num_players += 1
            tank1.image = UIImage(named:"Black0")
            player1status = "On"
            print("Running")
        }
        else{
            
            tank1.image = nil
            num_players -= 1
            player1status = "Off"
        }
    }
    
    @IBAction func touchplayer2(_ sender: Any) {
        if(player2status == "Off"){
            
            num_players += 1
            tank2.image = UIImage(named:"Red0")
            player2status = "On"
        }
        else{
            
            num_players -= 1
            tank2.image = nil
            player2status = "Off"
        }
    }
    
    @IBAction func touchplayer3(_ sender: Any) {
        if(player3status == "Off"){
            
            num_players += 1
            tank3.image = UIImage(named:"Blue0")
            player3status = "On"
        }
        else{
            
            num_players -= 1
            tank3.image = nil
            player3status = "Off"
        }
    }
    
    @IBAction func touchplayer4(_ sender: Any) {
        if(player4status == "Off"){
            
            num_players += 1
            tank4.image = UIImage(named:"Green0")
            player4status = "On"
        }
        else{
            
            num_players -= 1
            tank4.image = nil
            player4status = "Off"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gameoptions"){
            let game_options = segue.destination as! GameOptionsViewController
            game_options.num_players = num_players
            game_options.Music = Music
            game_options.Sound = Sound
            
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
