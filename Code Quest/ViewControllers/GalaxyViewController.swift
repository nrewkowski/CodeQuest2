//
//  GalaxyViewController.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 4/7/17.
//  Copyright © 2017 Spookle. All rights reserved.
//

import UIKit

class GalaxyViewController: UIViewController {
    
    var planetNumber:Int = -1
    

    override func viewDidLoad() {
        super.viewDidLoad()

            navigationItem.title = "Solar System 1"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*
        if let savedLevels = loadLevels() {
            levels += savedLevels
        } else {
            loadDefaultLevels()
        }
        if defaults.object(forKey: "musicVolume") != nil {
            musicVolume = defaults.float(forKey: "musicVolume")
        }
        
        if levels[levelsToUse[0]].cleared {
            level1HighScore.text = "Best: \(levels[levelsToUse[0]].highscore) moves"
            level1HighScore.accessibilityLabel="Best: \(levels[levelsToUse[0]].highscore) moves"
        } else {
            level1HighScore.text = "Not Yet Cleared"
            level1HighScore.accessibilityLabel="Level 1 not yet cleared"
        }
        
        if levels[levelsToUse[1]].cleared {
            level2HighScore.text = "Best: \(levels[levelsToUse[1]].highscore) moves"
            level2HighScore.accessibilityLabel="Best: \(levels[levelsToUse[1]].highscore) moves"
        } else {
            level2HighScore.text = "Not Yet Cleared"
            level2HighScore.accessibilityLabel="Level 2 not yet cleared"
        }
        
        if levels[levelsToUse[2]].cleared {
            level3HighScore.text = "Best: \(levels[levelsToUse[2]].highscore) moves"
            level3HighScore.accessibilityLabel="Best: \(levels[levelsToUse[2]].highscore) moves"
        } else {
            level3HighScore.text = "Not Yet Cleared"
            level3HighScore.accessibilityLabel="Level 3 not yet cleared"
        }*/
        //self.navigationController?.navigationBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let planetViewController = segue.destination as! MasterPlanetViewController
        
        planetViewController.planetNumber=planetNumber+1
        planetViewController.levelsToUse=[planetNumber*3, (planetNumber*3)+1, (planetNumber*3)+2]
    }

    @IBAction func planet1ButtonPressed(_ sender: Any) {
        planetNumber=0
        performSegue(withIdentifier: "toPlanetView", sender: nil)
        
    }
    
    @IBAction func planet2ButtonPressed(_ sender: Any) {
        planetNumber=1
        performSegue(withIdentifier: "toPlanetView", sender: nil)
    }
    
    
    @IBAction func planet3ButtonPressed(_ sender: Any) {
        planetNumber=2
        performSegue(withIdentifier: "toPlanetView", sender: nil)
    }
    
}
