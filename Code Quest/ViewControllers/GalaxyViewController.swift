//
//  GalaxyViewController.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 4/7/17.
//  Copyright © 2017 Spookle. All rights reserved.
//

import UIKit
import AVFoundation

class GalaxyViewController: UIViewController {
    
    var planetNumber:Int = -1
    var levels = [Level]()
    
    @IBOutlet weak var planet1: UIButton!
    @IBOutlet weak var planet2: UIButton!
    @IBOutlet weak var planet3: UIButton!
    @IBOutlet weak var planet4: UIButton!
    @IBOutlet weak var planet5: UIButton!
    
    @IBOutlet weak var planet1Completed: UILabel!
    @IBOutlet weak var planet1Stars: UILabel!
    @IBOutlet weak var planet2Completed: UILabel!
    @IBOutlet weak var planet2Stars: UILabel!
    @IBOutlet weak var planet3Completed: UILabel!
    @IBOutlet weak var planet3Stars: UILabel!
    @IBOutlet weak var planet4Completed: UILabel!
    @IBOutlet weak var planet4Stars: UILabel!
    @IBOutlet weak var planet5Completed: UILabel!
    @IBOutlet weak var planet5Stars: UILabel!
    
    
	let music2: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "LevelSelect", ofType:"mp3")!);
	var musicPlayer2 = AVAudioPlayer()
	
    override func viewDidLoad() {
        super.viewDidLoad()

            navigationItem.title = "Solar System 1"
        // Do any additional setup after loading the view.
    }
	
	///Loads levels from storage
	func loadLevels() -> [Level]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Level.ArchiveURL.path) as? [Level]
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
		
//		if let savedLevels = loadLevels() {
//			levels += savedLevels
//			var planet1LevelsCompleted=0
//			var planet1StarsGotten=0
//			var planet2LevelsCompleted=0
//			var planet2StarsGotten=0
//			var planet3LevelsCompleted=0
//			var planet3StarsGotten=0
//			
//			planet1StarsGotten = levels[0].starsGotten + levels[1].starsGotten + levels[2].starsGotten
//			planet2StarsGotten = levels[3].starsGotten + levels[4].starsGotten + levels[5].starsGotten
//			planet3StarsGotten = levels[6].starsGotten + levels[7].starsGotten + levels[8].starsGotten
//			
//			for i in 0 ..< 3 {
//				if levels[i].cleared {
//					planet1LevelsCompleted += 1
//				}
//			}
//			
//			for i in 3 ..< 6 {
//				if levels[i].cleared {
//					planet2LevelsCompleted += 1
//				}
//			}
//			
//			for i in 6 ..< 9 {
//				if levels[i].cleared {
//					planet3LevelsCompleted += 1
//				}
//			}
//			
//			planet1Completed.text = "Completed "+String(planet1LevelsCompleted)+" out of 3 levels"
//            planet2Completed.text = "Completed "+String(planet2LevelsCompleted)+" out of 3 levels"
//            planet3Completed.text = "Completed "+String(planet3LevelsCompleted)+" out of 3 levels"
//            
//            planet1Stars.text = "Stars Gotten: "+String(planet1StarsGotten)
//            planet2Stars.text = "Stars Gotten: "+String(planet2StarsGotten)
//            planet3Stars.text = "Stars Gotten: "+String(planet3StarsGotten)
//            
//            planet1.accessibilityLabel = "Planet 1, "+planet1Completed.text!+", "+planet1Stars.text!
//            planet2.accessibilityLabel = "Planet 2, "+planet2Completed.text!+", "+planet2Stars.text!
//            planet3.accessibilityLabel = "Planet 3, "+planet3Completed.text!+", "+planet3Stars.text!
//		}
		
		
    }
	
	override func viewDidAppear(_ animated: Bool) {
		do {
			try musicPlayer2 = AVAudioPlayer(contentsOf: music2)
			musicPlayer2.numberOfLoops = -1
			musicPlayer2.volume = 1.0 * musicVolume
			
			
			let sdelay : TimeInterval = 0.1
			let now = musicPlayer2.deviceCurrentTime
			//musicPlayer2.play(atTime: now+sdelay)
		} catch {
			print ("music failed")
		}
		if let savedLevels = loadLevels() {
			levels += savedLevels
			var planet1LevelsCompleted=0
			var planet1StarsGotten=0
			var planet2LevelsCompleted=0
			var planet2StarsGotten=0
			var planet3LevelsCompleted=0
			var planet3StarsGotten=0
			var planet4LevelsCompleted=0
			var planet4StarsGotten=0
			var planet5LevelsCompleted=0
			var planet5StarsGotten=0
			
			planet1StarsGotten = levels[0].starsGotten + levels[1].starsGotten + levels[2].starsGotten
			planet2StarsGotten = levels[3].starsGotten + levels[4].starsGotten + levels[5].starsGotten
			planet3StarsGotten = levels[6].starsGotten + levels[7].starsGotten + levels[8].starsGotten
			planet4StarsGotten = levels[9].starsGotten + levels[10].starsGotten + levels[11].starsGotten
			planet5StarsGotten = levels[12].starsGotten + levels[13].starsGotten + levels[14].starsGotten
			
			for i in 0 ..< 3 {
				if levels[i].cleared {
					planet1LevelsCompleted += 1
				}
			}
			
			for i in 3 ..< 6 {
				if levels[i].cleared {
					planet2LevelsCompleted += 1
				}
			}
			
			for i in 6 ..< 9 {
				if levels[i].cleared {
					planet3LevelsCompleted += 1
				}
			}
			for i in 9 ..< 12 {
				if levels[i].cleared {
					planet4LevelsCompleted += 1
				}
			}
			for i in 12 ..< 15 {
				if levels[i].cleared {
					planet5LevelsCompleted += 1
				}
			}
			
			planet1Completed.text = "Completed "+String(planet1LevelsCompleted)+" out of 3 levels"
			planet2Completed.text = "Completed "+String(planet2LevelsCompleted)+" out of 3 levels"
			planet3Completed.text = "Completed "+String(planet3LevelsCompleted)+" out of 3 levels"
			planet4Completed.text = "Completed "+String(planet4LevelsCompleted)+" out of 3 levels"
			planet5Completed.text = "Completed "+String(planet5LevelsCompleted)+" out of 3 levels"
			
			planet1Stars.text = "Stars Gotten: "+String(planet1StarsGotten)
			planet2Stars.text = "Stars Gotten: "+String(planet2StarsGotten)
			planet3Stars.text = "Stars Gotten: "+String(planet3StarsGotten)
			planet4Stars.text = "Stars Gotten: "+String(planet4StarsGotten)
			planet5Stars.text = "Stars Gotten: "+String(planet5StarsGotten)
			
			planet1.accessibilityLabel = "Planet 1, "+planet1Completed.text!+", "+planet1Stars.text!
			planet2.accessibilityLabel = "Planet 2, "+planet2Completed.text!+", "+planet2Stars.text!
			planet3.accessibilityLabel = "Planet 3, "+planet3Completed.text!+", "+planet3Stars.text!
			planet4.accessibilityLabel = "Planet 4, "+planet4Completed.text!+", "+planet4Stars.text!
			planet5.accessibilityLabel = "Planet 5, "+planet5Completed.text!+", "+planet5Stars.text!
		}
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
    
    @IBAction func planet4ButtonPressed(_ sender: Any) {
        planetNumber=3
        performSegue(withIdentifier: "toPlanetView", sender: nil)
    }
    
    @IBAction func planet5ButtonPressed(_ sender: Any) {
        planetNumber=4
        performSegue(withIdentifier: "toPlanetView", sender: nil)
    }
    
    
}
