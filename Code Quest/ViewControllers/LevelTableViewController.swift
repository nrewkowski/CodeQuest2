//
//  LevelTableViewController.swift
//  Code Quest
//
//  Created by OSX on 9/21/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit


let imageNames = ["left", "up", "down", "right", "blast_button"]
let commandSounds = [leftSound, rightSound, upSound, downSound, blastSound]

/// Renders level select screen
class LevelTableViewController: UITableViewController {
	
	///Array of level objects
    var levels = [Level]()
	var defaults = UserDefaults.standard
	
    override func viewDidLoad() {
        super.viewDidLoad()

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
		let level2 = Level(name: "Level 1-2", data: data2, startingLoc: (0, 0), goalLoc: (4, 2), tutorial: "Oh no! There seems to be obstacles in your path this time. They cannot be walked through. Find the shortest path back to the ship!")
		
		let data3 = [[1,1,1,1,1],
		             [2,2,1,2,2],
		             [2,2,1,2,2]]
		let level3 = Level(name: "Level 1-3", data: data3, startingLoc: (0, 0), goalLoc: (2, 2), tutorial: "Sometimes there might be branching paths. Make sure you chose the right one to make it back to the ship in the shortest amount of moves!")
		
		//Planet 2
		
		let data4 = [[1,2,2,2,2,2],
		             [1,2,2,1,2,2],
		             [1,1,4,1,1,1]]
		let level4 = Level(name: "Level 2-1", data: data4, startingLoc:(0,0), goalLoc:(3,1), tutorial:"Oh no! It seems we are out of fuel! While I do not have fuel we cannot leave this place! Make sure you pick up the fuel before returning to the ship or we cannot leave!")
		
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LevelTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LevelTableViewCell
        let level = levels[indexPath.row]
    
		print (level)
		print(indexPath)
		print(indexPath.row)
		print (level.highscore)
        cell.levelLabel.text = level.name
		if level.cleared {
			cell.highscoreLabel.text = "Best score: \(level.highscore) moves"
		} else {
			cell.highscoreLabel.text = "Not Yet Cleared"
		}

        return cell
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

	@IBAction func AddButton(_ sender: AnyObject) {
		let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "settings") as! settingsTableViewController
		vc.modalPresentationStyle = UIModalPresentationStyle.popover
		vc.parentTableView = self
		let popover: UIPopoverPresentationController = vc.popoverPresentationController!
		popover.barButtonItem = (sender as! UIBarButtonItem)
		present(vc, animated: true, completion: nil)
		
		

	}
	
	func newMaze () {
		let levelName = "Extra \(levels.count + 1)"
		let tutorialText = "Solve Mr Maze's confounding maze!"
		let newIndexPath = NSIndexPath(row: levels.count, section:0)
		levels.append(makeMazeLevel(name:levelName, tutorial: tutorialText))
		tableView.insertRows(at: [newIndexPath as IndexPath], with:.bottom)
		saveLevels()
	}
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStage" {
            let levelViewController = segue.destination as! LevelViewController
            if let selectedLevelCell = sender as? LevelTableViewCell {
                let indexPath = tableView.indexPath(for: selectedLevelCell)!
                let selectedLevel = levels[indexPath.row]
                levelViewController.level = selectedLevel
				levelViewController.parentLevelTableViewController = self
            }
        }
    }
	
	/*@IBAction func unwindToLevelList(sender: UIStoryboardSegue) {
		print("we just got a seque, I wonder who it's from")
		if let sourceViewController = sender.source as? ViewController, let level = sourceViewController.level {
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				levels[selectedIndexPath.row] = level
				tableView.reloadRows(at: [selectedIndexPath], with:.fade)
				
			}
		}
		saveLevels()
	}
    */

}
