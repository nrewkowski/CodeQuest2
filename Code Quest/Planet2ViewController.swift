//
//  Planet2ViewController.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 4/5/17.
//  Copyright © 2017 Spookle. All rights reserved.
//



import UIKit
import AVFoundation
import SpriteKit
import Darwin

class Planet2ViewController: UIViewController, PlanetViewController {
	
	///Array of level objects
	var levels = [Level]()
	var defaults = UserDefaults.standard
	
	
	@IBOutlet weak var level1HighScore: UILabel!
	@IBOutlet weak var level2HighScore: UILabel!
	@IBOutlet weak var level3HighScore: UILabel!
	
    @IBOutlet weak var level1button: UIButton!
    @IBOutlet weak var level2button: UIButton!
    @IBOutlet weak var level3button: UIButton!
    
    
	let music2: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "LevelSelect", ofType:"wav")!);
	var musicPlayer2 = AVAudioPlayer()
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		
		self.navigationItem.title="Planet 2"
        
        //level1button.setImage(UIImage(named: "fuel_grid")?.image, for: .normal)
		
        //level1button.currentImage?.maskWithColor(color: UIColor.red)
        //level1button.imageView?.image?.renderingMode = UIImageRenderingMode.alwaysTemplate
        level1button.imageView?.tintColor = UIColor.green
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
		
		if levels[3].cleared {
			level1HighScore.text = "Best: \(levels[3].highscore) moves"
			level1HighScore.accessibilityLabel="Best: \(levels[3].highscore) moves"
		} else {
			level1HighScore.text = "Not Yet Cleared"
			level1HighScore.accessibilityLabel="Level 1 not yet cleared"
		}
		
		if levels[3].cleared {
			level2HighScore.text = "Best: \(levels[4].highscore) moves"
			level2HighScore.accessibilityLabel="Best: \(levels[4].highscore) moves"
		} else {
			level2HighScore.text = "Not Yet Cleared"
			level2HighScore.accessibilityLabel="Level 2 not yet cleared"
		}
		
		if levels[3].cleared {
			level3HighScore.text = "Best: \(levels[5].highscore) moves"
			level3HighScore.accessibilityLabel="Best: \(levels[5].highscore) moves"
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
		let level1 = Level(name: "Level 1-1", data: data1, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "This is your ship's computer, Glados. I need you to return to me so that we can fly back to our home. To reach me simply walk right until you reach the ship.", starsGotten: 0, parNumMoves: 2, numOfMovesRequiredPerStar: [5,2,1])
		
		let data2 = [[1,1,1,1,1],
		             [2,2,2,2,1],
		             [2,2,2,2,1]]
		let level2 = Level(name: "Level 1-2", data: data2, startingLoc: (0, 0), goalLoc: (4, 2), tutorial: "Walls cannot be walked through. Find a way around the walls to reach the ship!", starsGotten: 0, parNumMoves: 3,numOfMovesRequiredPerStar: [5,3,2])
		
		let data3 = [[1,1,1,1,1],
		             [2,2,1,2,2],
		             [2,2,1,2,2]]
		let level3 = Level(name: "Level 1-3", data: data3, startingLoc: (0, 0), goalLoc: (2, 2), tutorial: "Make sure you take the correct path to get to the ship!", starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3])
		
		//Planet 2
		
		let data4 = [[1,2,2,2,2,2],
		             [1,2,2,1,2,2],
		             [1,1,4,1,1,1]]
		let level4 = Level(name: "Level 2-1", data: data4, startingLoc:(0,0), goalLoc:(3,1), tutorial:"Fuel levels low! We cannot leave while we don't have fuel! Make sure you pick some up!", starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3])
		
		let data5 = [[1,1,2,2],
		             [1,1,1,1],
		             [1,1,2,1],
		             [1,1,4,1]]
		
		
		let level5 = Level(name: "Level 2-2", data: data5, startingLoc: (0, 0), goalLoc: (3, 1), tutorial: "Fuel levels low! Make sure to grab the fuel in this area before returning to the ship!", starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3])
		
		let data6 = [[1,2,1,1,1],
		             [1,1,1,2,2],
		             [1,2,1,1,4]]
		
		let level6 = Level(name: "Level 2-3", data: data6, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "Fuel levels low! Make sure to grab the fuel in this area before returning to the ship!", starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3])
		
		let data7 = [[1,2,2,2,2,1],
		             [1,1,1,1,1,1],
		             [1,2,2,1,2,2],
		             [1,2,4,1,2,2]]
		
		let level7 = Level(name: "Level 7", data: data7, startingLoc: (0, 0), goalLoc: (0, 3), tutorial: "Make sure to pick up the rocket fuel!", starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3])
		
		//Planet 3
		let data8 = [[1,1,3,1,1]]
		
		let level8 = Level(name: "Level 8", data: data8, startingLoc: (0, 0), goalLoc: (4, 0), tutorial: "The wall in your path seems to have cracks in it. Try standing next to it and using your blaster to break through it!",starsGotten: 0, parNumMoves: 5,numOfMovesRequiredPerStar: [6,4,3])
		
		let data9 = [[1,2,2,1,2,2],
		             [1,2,2,3,2,2],
		             [1,1,1,1,3,4],
		             [2,2,2,2,2,2]]
		
		let level9 = Level(name: "Level 9", data: data9, startingLoc: (0, 0), goalLoc: (3, 0), tutorial: "Great! Now we're low on fuel and their are walls that need breaking! I'm sure it will be no problem for you!", starsGotten: 0, parNumMoves: 4,numOfMovesRequiredPerStar: [6,4,3])
		
		let data10 = [[1,3,3,1,3],
		              [2,2,2,2,1],
		              [2,4,1,3,1],
		              [2,2,2,2,1]]
		
		let level10 = Level(name: "Level 10", data: data10, startingLoc: (0, 0), goalLoc: (4, 3), tutorial: "We're almost home! Make sure you use everything you've learned so far to get back to the ship!", starsGotten: 0, parNumMoves: 5,numOfMovesRequiredPerStar: [6,4,3])
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
		let levelViewController = segue.destination as! PlanetLevelViewController
		levelViewController.planetNumber=2
		var selectedLevel: Level;
		selectedLevel = levels[3]
		var isALevel=true
		if segue.identifier=="p2l1" {
			selectedLevel = levels[3]
			levelViewController.levelNumber=1
			levelViewController.bestScore=levels[3].highscore
		}
		else if segue.identifier=="p2l2"{
			selectedLevel=levels[4]
			levelViewController.levelNumber=2
			levelViewController.bestScore=levels[4].highscore
		}
		else if segue.identifier=="p2l3"{
			selectedLevel=levels[5]
			levelViewController.levelNumber=3
			levelViewController.bestScore=levels[5].highscore
		}
        else if segue.identifier=="moon1"{
            selectedLevel=levels[6]
            levelViewController.levelNumber=4
            levelViewController.bestScore=levels[6].highscore
        }
		else{
			isALevel = false
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
	
	override func viewWillDisappear(_ animated : Bool) {
		//super.viewWillDisappear(animated)
		musicPlayer2.stop()
		//drumPlayer.stop()
	}
	
	
}

extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}