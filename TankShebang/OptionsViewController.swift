//
//  OptionsViewController.swift
//  TankShebang
//
//  Created by Robert Beit on 12/9/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    
    @IBOutlet weak var SoundButton: UIButton!
    
    @IBOutlet weak var MusicButton: UIButton!
    
    var sound = String()
    var music = String()
    
    
    
    @IBAction func TouchSound(_ sender: Any) {
        if( SoundButton.titleLabel?.text == "On"){
            SoundButton.setTitle("Off", for: .normal)
            sound = "Off"
        }
        else if(SoundButton.titleLabel?.text == "Off"){
            SoundButton.setTitle("On", for: .normal)
            sound = "On"
            
        }
        
    }
    
    @IBAction func TouchMusic(_ sender: Any) {
        if(MusicButton.titleLabel?.text == "On"){
            MusicButton.setTitle("Off", for: .normal)
            music = "Off"
        }
        else if(MusicButton.titleLabel?.text == "Off"){
            MusicButton.setTitle("On", for: .normal)
            music = "On"
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let titleview = segue.destination as! TitleViewController
        titleview.Sound = sound
        titleview.Music = music
        
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
