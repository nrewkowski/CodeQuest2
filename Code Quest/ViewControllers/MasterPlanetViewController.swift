//
//  MasterPlanetViewController.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 4/7/17.
//  Copyright © 2017 Spookle. All rights reserved.
//

import Foundation

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

class MasterPlanetViewController: UIViewController, PlanetViewController {
	
	///Array of level objects
	var levels = [Level]()
	var defaults = UserDefaults.standard
	
	var levelsToUse:[Int] = []
	
	var planetNumber:Int = -1
	
	var levelNumber:Int = -1
	var nextLevelHint:String=""
	
	
	@IBOutlet weak var level1HighScore: UILabel!
	@IBOutlet weak var level2HighScore: UILabel!
	@IBOutlet weak var level3HighScore: UILabel!
    @IBOutlet weak var planetImage: UIImageView!
    @IBOutlet weak var nextPlanetLabel: UILabel!
    @IBOutlet weak var nextPlanetArrow: UIButton!
    @IBOutlet weak var moon1Button: UIButton!
    @IBOutlet weak var level1Button: UIButton!
    @IBOutlet weak var level2Button: UIButton!
    @IBOutlet weak var level3Button: UIButton!
    
    @IBOutlet weak var level1star1: UIButton!
    @IBOutlet weak var level1star2: UIButton!
    @IBOutlet weak var level1star3: UIButton!
    
    @IBOutlet weak var level2star1: UIButton!
    @IBOutlet weak var level2star2: UIButton!
    @IBOutlet weak var level2star3: UIButton!
    
    @IBOutlet weak var level3star1: UIButton!
    @IBOutlet weak var level3star2: UIButton!
    @IBOutlet weak var level3star3: UIButton!
    
    var level1stars:[UIButton] = []
    var level2stars:[UIButton] = []
    var level3stars:[UIButton] = []
	
	let music2: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "LevelSelect", ofType:"mp3")!);
	var musicPlayer2 = AVAudioPlayer()
	override func viewDidLoad() {
		super.viewDidLoad()
        
        if (planetNumber == 2){
            level1Button.setImage(UIImage(named: "alien2"), for: .normal)
            level2Button.setImage(UIImage(named: "alien2"), for: .normal)
            level3Button.setImage(UIImage(named: "alien2"), for: .normal)
        }
        else if (planetNumber == 3){
            level1Button.setImage(UIImage(named: "alien3"), for: .normal)
            level2Button.setImage(UIImage(named: "alien3"), for: .normal)
            level3Button.setImage(UIImage(named: "alien3"), for: .normal)
        }
		
		planetImage.image=UIImage(named: "planet"+String(planetNumber))
		self.navigationItem.title="Planet "+String(planetNumber)
        
        nextPlanetLabel.text = "Planet "+String(planetNumber+1)
        
        nextPlanetArrow.accessibilityLabel = "Go to planet "+String(planetNumber+1)

		level1stars=[level1star1, level1star2, level1star3]
        level2stars=[level2star1, level2star2, level2star3]
        level3stars=[level3star1, level3star2, level3star3]
        
        
		//let MrMaze = Maze(width:11, height:7)
		//levels.append(LevelFromMaze(maze: MrMaze, name: "Mr Maze's Level", tutorial:"This is Mr Maze's level"))
//		if let savedLevels = loadLevels() {
//			levels += savedLevels
//		} else {
//			loadDefaultLevels()
//		}
//		if defaults.object(forKey: "musicVolume") != nil {
//			musicVolume = defaults.float(forKey: "musicVolume")
//		}
//		
//		if levels[levelsToUse[0]].cleared {
//			level1HighScore.text = "Best: \(levels[levelsToUse[0]].highscore) moves"
//			level1HighScore.accessibilityLabel="Best: \(levels[levelsToUse[0]].highscore) moves"
//		} else {
//			level1HighScore.text = "Not Yet Cleared"
//			level1HighScore.accessibilityLabel="Level 1 not yet cleared"
//		}
//		
//		if levels[levelsToUse[1]].cleared {
//			level2HighScore.text = "Best: \(levels[levelsToUse[1]].highscore) moves"
//			level2HighScore.accessibilityLabel="Best: \(levels[levelsToUse[1]].highscore) moves"
//		} else {
//			level2HighScore.text = "Not Yet Cleared"
//			level2HighScore.accessibilityLabel="Level 2 not yet cleared"
//		}
//		
//		if levels[levelsToUse[2]].cleared {
//			level3HighScore.text = "Best: \(levels[levelsToUse[2]].highscore) moves"
//			level3HighScore.accessibilityLabel="Best: \(levels[levelsToUse[2]].highscore) moves"
//		} else {
//			level3HighScore.text = "Not Yet Cleared"
//			level3HighScore.accessibilityLabel="Level 3 not yet cleared"
//		}
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
        }
        
        level1Button.accessibilityLabel = "Level 1, best score = " + String(levels[levelsToUse[0]].highscore) + "moves"
        
        level2Button.accessibilityLabel = "Level 2, best score = " + String(levels[levelsToUse[1]].highscore) + "moves"
        
        level3Button.accessibilityLabel = "Level 3, best score = " + String(levels[levelsToUse[2]].highscore) + "moves"
        
        for i in 0 ..< ((levels[levelsToUse[0]].starsGotten as Int)) {
            level1stars[i].isEnabled=true
        }
        
        for i in 0 ..< ((levels[levelsToUse[1]].starsGotten as Int)) {
            level2stars[i].isEnabled=true
        }
        
        for i in 0 ..< ((levels[levelsToUse[2]].starsGotten as Int)) {
            level3stars[i].isEnabled=true
        }
        
        view.accessibilityElements = [level1Button, level2Button, level3Button, moon1Button, nextPlanetArrow]
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
        let level1 = Level(name: "Level 1-1", data: data1, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "This is your ship's computer, Glados. I need you to return to me so that we can fly back to our home. To reach count the steps needed then move that many steps to the right!", starsGotten: 0, parNumMoves: 2, numOfMovesRequiredPerStar: [5,2,1])
        
        
        let data2 = [[1,1,1,1,1],
                     [2,2,2,2,1],
                     [2,2,2,2,1]]
        let level2 = Level(name: "Level 1-2", data: data2, startingLoc: (0, 0), goalLoc: (4, 2), tutorial: "Walls cannot be walked through. Move right and down to reach the ship! Remember to count your steps before moving!", starsGotten: 0, parNumMoves: 3,numOfMovesRequiredPerStar: [5,3,2])
        
        let data3 = [[1,1,1,1,1],
                     [2,2,1,2,2],
                     [2,2,1,2,2]]
        let level3 = Level(name: "Level 1-3", data: data3, startingLoc: (0, 0), goalLoc: (2, 2), tutorial: "Make sure you take the correct path to get to the ship!", starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3])
        
        //Planet 2
        
        let data4 = [[1,1,1,4,1,1]]
        let level4 = Level(name: "Level 2-1", data: data4, startingLoc:(0,0), goalLoc:(5,0), tutorial:"An alien needs your help! Be sure to pick up the alien before returning to your ship!", starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [5,2,1])
        
        let data5 = [[1,1,2,2],
                     [2,1,2,1],
                     [2,1,2,1],
                     [2,1,4,1]]
        
        
        let level5 = Level(name: "Level 2-2", data: data5, startingLoc: (0, 0), goalLoc: (3, 1), tutorial: "Another alien is lost! Remember to pick them up before going to the ship!", starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3])
        
        let data6 = [[1,2,1,1,1],
                     [1,1,1,2,2],
                     [2,2,1,1,4]]
        
        let level6 = Level(name: "Level 2-3", data: data6, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "Another alien is lost! You need to pick them up before leaving the planet! You may have to backtrack!", starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3])
        
        let data7 = [[1,2,2,2,2,2],
                     [1,1,1,1,2,2],
                     [2,2,2,1,2,2],
                     [1,1,4,1,2,2]]
        
        let level7 = Level(name: "Level 7", data: data7, startingLoc: (0, 0), goalLoc: (0, 3), tutorial: "An alien needs your help! Remember you cannot leave until you have saved the alien!", starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3])
        
        //Planet 3
        let data8 = [[1,1,3,1,1]]
        
        let level8 = Level(name: "Level 3-1", data: data8, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "The wall in your path seems to have cracks in it. Try standing next to it and using your blaster to break through it!",starsGotten: 0, parNumMoves: 5,numOfMovesRequiredPerStar: [6,4,3])
        
        let data9 = [[1,2,2,2,2],
                     [3,2,2,2,2],
                     [1,3,1,1,1]]
        
        let level9 = Level(name: "Level 3-2", data: data9, startingLoc: (0, 0), goalLoc: (4, 2), tutorial: "The blaster will destroy walls on all 4 sides of you! Make sure to save the alien before continuing on to the ship!", starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3])
        
        let data10 = [[1,3,3,1,3],
                      [2,2,2,2,1],
                      [2,1,4,3,1],
                      [2,2,2,2,2]]
        
        let level10 = Level(name: "Level 3-3", data: data10, startingLoc: (0, 0), goalLoc: (1, 2), tutorial: "Use all you have learned to break the walls, save the alien, and get to the ship!", starsGotten: 0, parNumMoves: 5,numOfMovesRequiredPerStar: [6,4,3])
        
        //Planet 4
        
        let data11 = [[1,1,4,1,1]]
        
        let level11 = Level(name: "Level 4-1", data: data11, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "Some walls are stronger than others and may take multiple blasts to destroy! Try it on this wall!", starsGotten: 0, parNumMoves: 5,numOfMovesRequiredPerStar: [5,2,1])
		
		let data12 = [[1,2,2,2,1],
		              [1,1,5,1,1]]
		
		let level12 = Level(name: "Level 4-2", data: data12, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "This wall is even stronger and will require one more hit with your blaster!", starsGotten: 0, parNumMoves: 5,numOfMovesRequiredPerStar: [5,2,1])
		
		let data13 = [[1,2,2,2,2],
		              [1,1,2,2,1],
		              [2,6,1,1,1]]
		
		let level13 = Level(name: "Level 4-3", data: data13, startingLoc: (0, 0), goalLoc: (4, 2), tutorial: "This is the strongest wall and will require the most hits with your blaster!", starsGotten: 0, parNumMoves: 5,numOfMovesRequiredPerStar: [5,2,1])
		
		//Planet 5
		let data14 = [[1,1,4,1,1]]
		
		let level14 = Level(name: "Level 5-1", data: data14, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "Using the blaster command so many times can bet annoying! Try using the loop feature to break this wall!", starsGotten: 0, parNumMoves: 5,numOfMovesRequiredPerStar: [5,2,1])
		
		let data15 = [[1,2,2,2,1],
		              [1,1,3,1,1]]
		
		let level15 = Level(name: "Level 5-2", data: data15, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "The loop function can also be used on movements to get a better score! Try it here!", starsGotten: 0, parNumMoves: 5,numOfMovesRequiredPerStar: [5,2,1])
		
		let data16 = [[1,2,2,2,2],
		              [1,2,1,1,1],
		              [1,1,5,2,1]]
		
		let level16 = Level(name: "Level 5-3", data: data16, startingLoc: (0, 0), goalLoc: (4, 2), tutorial: "Use loops to get through this level as quickly as possible!", starsGotten: 0, parNumMoves: 5,numOfMovesRequiredPerStar: [5,2,1])
		
		
        levels += [level1, level2, level3, level4, level5, level6, level7, level8, level9, level10, level11, level12, level13, level14, level15, level16]
        saveLevels()	}
	
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
			newtutorial = tutorial + " There are \(fuelCount) aliens to collect."
		} else {
			newtutorial = tutorial
		}
		return Level(name: name, data: levelData, startingLoc:(0,0), goalLoc: (levelX-5, levelY-5), tutorial: newtutorial, starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3]) //we won't be able to use par or numofmovesrequiredperstar for random levels (or they could be innacurate)
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
		if (segue.identifier == "toLevel"){ //this needs to be changed....reload this viewcontroller with new data instead (FOR TO NEXT PLANET)
			let levelViewController = segue.destination as! PlanetLevelViewController
			
			
			levelViewController.planetNumber = planetNumber
			var selectedLevel: Level;
			selectedLevel = levels[levelsToUse[levelNumber]]
			var isALevel=true;
//			if segue.identifier=="p"+String(planetNumber)+"l"+String(levelNumber) {
//				selectedLevel = levels[levelsToUse[0]]
//				levelViewController.levelNumber=1
//				levelViewController.bestScore=levels[levelsToUse[0]].highscore
//			}
//			else if segue.identifier=="p1l2"{
//				selectedLevel=levels[levelsToUse[1]]
//				levelViewController.levelNumber=2
//				levelViewController.bestScore=levels[levelsToUse[1]].highscore
//			}
//			else if segue.identifier=="p1l3"{
//				selectedLevel=levels[levelsToUse[2]]
//				levelViewController.levelNumber=3
//				levelViewController.bestScore=levels[levelsToUse[2]].highscore
//			}
//			else{
//				isALevel=false
//			}
			
			if (levelNumber == -1){
				isALevel=false
			}
			else{
				selectedLevel = levels[levelsToUse[levelNumber]]
				levelViewController.levelNumber=levelNumber
				levelViewController.bestScore=levels[levelsToUse[levelNumber]].highscore
			}
			
			if (isALevel) {
				levelViewController.level = selectedLevel
				levelViewController.parentPlanetViewController = self
				
				var layoutText = ""
				let levelHeight = selectedLevel.data.count
				let levelWidth = selectedLevel.data[0].count
				let gridString = "The level is "+String(levelHeight)+" rows and "+String(levelWidth)+" columns."
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
				levelViewController.hint=nextLevelHint
				levelViewController.levels=levels
				levelViewController.levelsToUse=levelsToUse
				levelViewController.isFirstViewControllerOnStack = true
				//musicPlayer2.stop()
			}
		}
	}
	
	override func viewWillDisappear(_ animated : Bool) {
		//super.viewWillDisappear(animated)
		musicPlayer2.stop()
		//drumPlayer.stop()
	}
	
    
    @IBAction func level1ButtonPressed(_ sender: Any) {
        levelNumber=0
        performSegue(withIdentifier: "toLevel", sender: nil)
    }
    
    @IBAction func level2ButtonPressed(_ sender: Any) {
        levelNumber=1
        performSegue(withIdentifier: "toLevel", sender: nil)
    }
    
    @IBAction func level3ButtonPressed(_ sender: Any) {
        levelNumber=2
        performSegue(withIdentifier: "toLevel", sender: nil)
    }
    
    @IBAction func moon1ButtonPressed(_ sender: Any) {
    }
    
    
    
	
}
