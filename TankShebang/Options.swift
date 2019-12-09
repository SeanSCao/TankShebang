//
//  Options.swift
//  TankShebang
//
//  Created by Robert Beit on 11/28/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import UIKit

class Options: UIViewController {

    
    @IBOutlet weak var music: UIButton!
    @IBOutlet weak var sound: UIButton!
    var sound1 = String()
    var music1 = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var titleview = segue.destination as! TitleViewController
        titleview.Sound = sound1
        titleview.Music = music1
        
    }
    
    @IBAction func soundeffects(_ sender: Any) {
        if( sound.titleLabel?.text == "On"){
            sound.setTitle("Off", for: .normal)
            sound1 = "Off"
        }
        if(sound.titleLabel?.text == "Off"){
            sound.setTitle("On", for: .normal)
            sound1 = "On"
            
        }
    }
    
    @IBAction func musiceffect(_ sender: Any) {
        if(music.titleLabel?.text == "On"){
            music.setTitle("Off", for: .normal)
            music1 = "Off"
        }
        if(music.titleLabel?.text == "Off"){
            music.setTitle("On", for: .normal)
            music1 = "On"
            
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
