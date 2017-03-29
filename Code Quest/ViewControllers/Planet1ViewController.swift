//
//  Planet1ViewController.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 3/28/17.
//  Copyright © 2017 Spookle. All rights reserved.
//

import UIKit

class Planet1ViewController: UIViewController {

	///Array of level objects
	var levels = [Level]()
	var defaults = UserDefaults.standard
    
    
    @IBOutlet weak var level1HighScore: UILabel!
    @IBOutlet weak var level2HighScore: UILabel!
    @IBOutlet weak var level3HighScore: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationItem.title="Planet 1"

		//let MrMaze = Maze(width:11, height:7)
		//levels.append(LevelFromMaze(maze: MrMaze, name: "Mr Maze's Level", tutorial:"This is Mr Maze's level"))
		if let savedLevels = loadLevels() {
			levels += savedLevels
		} else {
			loadDefaultLevels()
		}
		if defaults.object(forKey: "musicVolume") != nil {
			musicVolume = defaults.float(forKey: "musicVolume")
		}
        
		if levels[0].cleared {
			level1HighScore.text = "Best: \(levels[0].highscore) moves"
            level1HighScore.accessibilityLabel="Best: \(levels[0].highscore) moves"
		} else {
			level1HighScore.text = "Not Yet Cleared"
            level1HighScore.accessibilityLabel="Level 1 not yet cleared"
		}
		
		if levels[1].cleared {
			level2HighScore.text = "Best: \(levels[1].highscore) moves"
            level2HighScore.accessibilityLabel="Best: \(levels[1].highscore) moves"
		} else {
			level2HighScore.text = "Not Yet Cleared"
            level2HighScore.accessibilityLabel="Level 2 not yet cleared"
		}
		
		if levels[2].cleared {
			level3HighScore.text = "Best: \(levels[2].highscore) moves"
            level3HighScore.accessibilityLabel="Best: \(levels[2].highscore) moves"
		} else {
			level3HighScore.text = "Not Yet Cleared"
            level3HighScore.accessibilityLabel="Level 3 not yet cleared"
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	///Saves levels to storage
	func saveLevels () {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(levels, toFile: Level.ArchiveURL.path)
		if !isSuccessfulSave {
			print("failed to save levels...")
		}
	}
	
	///Loads levels from storage
	func loadLevels() -> [Level]? {
		return NSKeyedUnarchiver.unarchiveObject(withFile: Level.ArchiveURL.path) as? [Level]
	}
	
	/// Contains data for built in levels, adds them to level array, and saves them
	func loadDefaultLevels() {
		//let data1 = [[2,2,2,2,2,2],
		//             [2,1,1,1,1,2],
		//             [2,2,2,2,2,2]]
		//let level1 = Level(name: "Level 1", data: data1, startingLoc: (1, 1), goalLoc: (4, 1), tutorial: "Bring the player to the goal!")
		//Planet 1
		let data1 = [[1,1,1,1,1]]
		let level1 = Level(name: "Level 1-1", data: data1, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "This is your ship's computer, Glados. I need you to return to me so that we can fly back to our home. To reach me simply walk right until you reach the ship.")
		
		let data2 = [[1,1,1,1,1],
		             [2,2,2,2,1],
		             [2,2,2,2,1]]
		let level2 = Level(name: "Level 1-2", data: data2, startingLoc: (0, 0), goalLoc: (4, 2), tutorial: "Walls cannot be walked through. Find a way around the walls to reach the ship!")
		
		let data3 = [[1,1,1,1,1],
		             [2,2,1,2,2],
		             [2,2,1,2,2]]
		let level3 = Level(name: "Level 1-3", data: data3, startingLoc: (0, 0), goalLoc: (2, 2), tutorial: "Make sure you take the correct path to get to the ship!")
		
		//Planet 2
		
		let data4 = [[1,2,2,2,2,2],
		             [1,2,2,1,2,2],
		             [1,1,4,1,1,1]]
		let level4 = Level(name: "Level 2-1", data: data4, startingLoc:(0,0), goalLoc:(3,1), tutorial:"Fuel levels low! We cannot leave while we don't have fuel! Make sure you pick some up!")
		
		let data5 = [[1,1,2,2],
		             [1,1,1,1],
		             [1,1,2,1],
		             [1,1,4,1]]
		
		
		let level5 = Level(name: "Level 2-2", data: data5, startingLoc: (0, 0), goalLoc: (3, 1), tutorial: "Fuel levels low! Make sure to grab the fuel in this area before returning to the ship!")
		
		let data6 = [[1,2,1,1,1],
		             [1,1,1,2,2],
		             [1,2,1,1,4]]
		
		let level6 = Level(name: "Level 2-3", data: data6, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "Fuel levels low! Make sure to grab the fuel in this area before returning to the ship!")
		
		let data7 = [[1,2,2,2,2,1],
		             [1,1,1,1,1,1],
		             [1,2,2,1,2,2],
		             [1,2,4,1,2,2]]
		
		let level7 = Level(name: "Level 7", data: data7, startingLoc: (0, 0), goalLoc: (0, 3), tutorial: "Make sure to pick up the rocket fuel!")
		
		//Planet 3
		let data8 = [[1,1,3,1,1]]
		
		let level8 = Level(name: "Level 8", data: data8, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "The wall in your path seems to have cracks in it. Try standing next to it and using your blaster to break through it!")
		
		let data9 = [[1,2,2,1,2,2],
		             [1,2,2,3,2,2],
		             [1,1,1,1,3,4],
		             [2,2,2,2,2,2]]
		
		let level9 = Level(name: "Level 9", data: data9, startingLoc: (0, 0), goalLoc: (3, 0), tutorial: "Great! Now we're low on fuel and their are walls that need breaking! I'm sure it will be no problem for you!")
		
		let data10 = [[1,3,3,1,3],
		              [2,2,2,2,1],
		              [2,4,1,3,1],
		              [2,2,2,2,1]]
		
		let level10 = Level(name: "Level 10", data: data10, startingLoc: (0, 0), goalLoc: (4, 3), tutorial: "We're almost home! Make sure you use everything you've learned so far to get back to the ship!")
		
		levels += [level1, level2, level3, level4, level5, level6, level7, level8, level9, level10]
		saveLevels()
	}

	///Given a maze, returns a level
	func LevelFromMaze(maze: Maze, name: String, tutorial: String) -> Level {
		let levelY = maze.data.count
		let levelX = maze.data[0].count
		var levelData =  [[Int]](repeating: [Int](repeating:0, count:levelX - 4), count: levelY - 4)
		let newtutorial : String
		var fuelCount = 0
		print(maze.data)
		for i in 2 ..< (levelY - 2) {
			for j in 2 ..< (levelX - 2) {
				
				var thisCell = maze.data[i][j] == Maze.Cell.Wall ? 2 : 1
				if !(i == 2 && j == (2)) && !(i == (levelY-3) && (j == (levelX-3))) && thisCell == 1 {
					if arc4random_uniform(100) < 3 {
						thisCell = 4
						fuelCount += 1
					} else if arc4random_uniform(100) < 10 {
						thisCell = 3
					}
				}
				levelData[i - 2][j - 2] = thisCell
			}
		}
		print(levelData)
		if fuelCount != 0 {
			newtutorial = tutorial + " There are \(fuelCount) fuel cans to collect."
		} else {
			newtutorial = tutorial
		}
		return Level(name: name, data: levelData, startingLoc:(0,0), goalLoc: (levelX-5, levelY-5), tutorial: newtutorial)
	}
	
	///Generates a random level
	func makeMazeLevel(name: String, tutorial:String) -> Level {
		let levelX = 5 + Int(arc4random_uniform(4) * 2)
		let levelY = 3 + Int(arc4random_uniform(2) * 2)
		let mrMaze = Maze(width: levelX + 4, height: levelY + 4)
		return LevelFromMaze(maze: mrMaze, name: name, tutorial: tutorial)
	}

	func newMaze () {
		let levelName = "Extra \(levels.count + 1)"
		let tutorialText = "Solve Mr Maze's confounding maze!"
		let newIndexPath = NSIndexPath(row: levels.count, section:0)
		levels.append(makeMazeLevel(name:levelName, tutorial: tutorialText))
		//tableView.insertRows(at: [newIndexPath as IndexPath], with:.bottom)
		saveLevels()
	}

	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let levelViewController = segue.destination as! PlanetLevelViewController
        var selectedLevel: Level;
        if segue.identifier=="p1l1" {
            selectedLevel = levels[0]
        }
        else if segue.identifier=="p1l2"{
            selectedLevel=levels[1]
        }
        else {
            selectedLevel=levels[2]
        }
		levelViewController.level = selectedLevel
		levelViewController.devParentLevelTableViewController = self
    }
	

}
