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
