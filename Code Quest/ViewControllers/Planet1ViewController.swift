//
//  Planet1ViewController.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 3/28/17.
//  Copyright © 2017 Spookle. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit
import Darwin

class Planet1ViewController: UIViewController, PlanetViewController {

	///Array of level objects
	var levels = [Level]()
	var defaults = UserDefaults.standard
    
    
    @IBOutlet weak var level1HighScore: UILabel!
    @IBOutlet weak var level2HighScore: UILabel!
    @IBOutlet weak var level3HighScore: UILabel!
    
	let music2: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "LevelSelect", ofType:"mp3")!);
	var musicPlayer2 = AVAudioPlayer()
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
	
	override func viewDidAppear(_ animated: Bool) {
		do {
			try musicPlayer2 = AVAudioPlayer(contentsOf: music2)
			musicPlayer2.numberOfLoops = -1
			musicPlayer2.volume = 1.0 * musicVolume
			
			
			let sdelay : TimeInterval = 0.1
			let now = musicPlayer2.deviceCurrentTime
			musicPlayer2.play(atTime: now+sdelay)
		} catch {
			print ("music failed")
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
		let level1 = Level(name: "Level 1-1", data: data1, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "This is your ship's computer, Glados. I need you to return to me so that we can fly back to our home. To reach me simply walk right until you reach the ship. Remember to count your steps before moving!", starsGotten: 0, parNumMoves: 2, numOfMovesRequiredPerStar: [5,2,1])
		
		let data2 = [[1,1,1,1,1],
		             [2,2,2,2,1],
		             [2,2,2,2,1]]
		let level2 = Level(name: "Level 1-2", data: data2, startingLoc: (0, 0), goalLoc: (4, 2), tutorial: "Walls cannot be walked through. Find a way around the walls by moving right and down to reach the ship!", starsGotten: 0, parNumMoves: 3,numOfMovesRequiredPerStar: [5,3,2])
		
		let data3 = [[1,1,1,1,1],
		             [2,2,1,2,2],
		             [2,2,1,2,2]]
		let level3 = Level(name: "Level 1-3", data: data3, startingLoc: (0, 0), goalLoc: (2, 2), tutorial: "Make sure you take the correct path to get to the ship! Remember to count the steps before you move!", starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3])
		
		levels += [level1, level2, level3]
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
		return Level(name: name, data: levelData, startingLoc:(0,0), goalLoc: (levelX-5, levelY-5), tutorial: newtutorial, starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3])
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
		if (segue.identifier != "toP2"){
			let levelViewController = segue.destination as! PlanetLevelViewController
			
			
			levelViewController.planetNumber=1
			var selectedLevel: Level;
			selectedLevel = levels[0]
			var isALevel=true;
			if segue.identifier=="p1l1" {
				selectedLevel = levels[0]
				levelViewController.levelNumber=1
				levelViewController.bestScore=levels[0].highscore
			}
			else if segue.identifier=="p1l2"{
				selectedLevel=levels[1]
				levelViewController.levelNumber=2
				levelViewController.bestScore=levels[1].highscore
			}
			else if segue.identifier=="p1l3"{
				selectedLevel=levels[2]
				levelViewController.levelNumber=3
				levelViewController.bestScore=levels[2].highscore
			}
			else{
				isALevel=false
			}
			if (isALevel) {
				levelViewController.level = selectedLevel
				levelViewController.parentPlanetViewController = self
				
				var layoutText = ""
				let levelHeight = selectedLevel.data.count
				let levelWidth = selectedLevel.data[0].count
				let gridString = "The level is "+String(levelHeight)+" rows tall and "+String(levelWidth)+" columns wide."
				print(gridString)
				let playerString = "The player is located at row 1 and column 1. "
				let goalRow = selectedLevel.goalLoc.1 + 1
				let goalColumn = selectedLevel.goalLoc.0 + 1
				let goalString = "The rocket ship is located at row " + String(goalRow) + ", column " + String(goalColumn) + ". "
				print(goalString)
				
				var alienLocation : (Int,Int) = (-1,-1)
				
				//DispatchQueue.main.sync{
					var i = 0
					for row in selectedLevel.data {
						if (row.contains(4)) {
							alienLocation = ( Int(i) + 1,Int(row.index(of: 4)!) + 1)
						}
						i += 1
					}
				//}
				
				var alienString = ""
				
				if (alienLocation == (-1,-1)){
					alienString = "There is no alien in this level."
				}
				else{
					alienString = "The alien is located at row "+String(alienLocation.0)+", column "+String(alienLocation.1)+"."
				}
				
				print(alienString)
				layoutText = gridString+playerString+goalString+alienString
				print(layoutText)
				levelViewController.layoutText=layoutText
				//musicPlayer2.stop()
			}
		}
    }
	
	override func viewWillDisappear(_ animated : Bool) {
		//super.viewWillDisappear(animated)
		musicPlayer2.stop()
		//drumPlayer.stop()
	}
	
	
}
