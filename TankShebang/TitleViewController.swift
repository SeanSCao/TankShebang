//
//  TitleViewController.swift
//  TankShebang
//
//  Created by Robert Beit on 12/9/19.
//  Copyright © 2019 Sean Cao, Robert Beit, Aryan Aru Agarwal. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    var Music = String()
    var Sound = String()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PlayerSelect"){
            let game_options = segue.destination as! PlayerSelectViewController
            game_options.Music = Music
            game_options.Sound = Sound
            
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Music)
        print(Sound)

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
