//
//  DevLevelViewController.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 3/22/17.
//  Copyright © 2017 Spookle. All rights reserved.
//



import UIKit
import AVFoundation
import SpriteKit
import Darwin


/// Primary game controller. Contains most game state information
class DevLevelViewController: LevelViewController {
	

	
	
	
	/// Controls game logic
	override func viewDidLoad() {
		
		self.view.backgroundColor = UIColor(red: 27.0/256.0, green: 40.0/256.0, blue: 54.0/256.0, alpha: 1.0)
		
		super.viewDidLoad()
		
		//add audio players
		do {
			try musicPlayer = AVAudioPlayer(contentsOf: music)
			try drumPlayer = AVAudioPlayer(contentsOf: drum)
			musicPlayer.numberOfLoops = -1
			drumPlayer.numberOfLoops = -1
			musicPlayer.volume = 1.0 * musicVolume
			
			
			drumPlayer.volume = 0
			let sdelay : TimeInterval = 0.1
			let now = musicPlayer.deviceCurrentTime
			musicPlayer.play(atTime: now+sdelay)
			drumPlayer.play(atTime: now+sdelay)
		} catch {
			print ("music failed")
		}
		
		
		//allows for tap input
		let touchOnResetRecognizer = UITapGestureRecognizer(target: self, action: #selector (self.tapReset (_:)))
		self.view.addGestureRecognizer(touchOnResetRecognizer)
		
		//i don't know why this is called testgrid...it seems to be the initial grid
		if let testGrid = (level?.data)! as [[Int]]? {
			playerLoc = level!.startingLoc
			goalLoc = level!.goalLoc
			for y in 0..<testGrid.count {
				tileArray.append([])
				for x in 0..<testGrid[y].count {
					var cell:gameCell
					switch testGrid[y][x] {      //Instantiate gameCells based on input array
					case 1:
						cell = floorCell(isWall: false, isFuel: false)
					case 2:
						cell = wallCell()
					case 3:
						cell = floorCell(isWall: true, isFuel: false)
						breakBlocks.append(cell as! floorCell)
					case 4:
						cell = floorCell(isWall: false, isFuel: true)
						fuelCells.append(cell as! floorCell)
					default:
						cell = floorCell(isWall: false, isFuel: false)
					}
					cell.frame = CGRect(x: LevelViewController.scaleDims(input: LevelViewController.moveInc*x, x: true), y: LevelViewController.scaleDims(input: 64+LevelViewController.moveInc*y, x: false), width: LevelViewController.scaleDims(input: LevelViewController.moveInc, x: true), height: LevelViewController.scaleDims(input: LevelViewController.moveInc, x: false))
					self.view.addSubview(cell)
					self.tileArray[y].append(cell)  //Store gameCells in array for accessing
				}
			}
			if let player = tileArray[playerLoc.1][playerLoc.0] as? floorCell {
				player.makePlayer()       //Draw player on starting position cell
			}
			if let goal = tileArray[goalLoc.1][goalLoc.0] as? floorCell {
				goal.makeGoal()           //Draw goal on position cell
			}
		}
		
		
		//populates the string that is read in the beginning of the level
		if let tutorialString = (level?.tutorialText)! as String? {
			//let alert = UIAlertController(title: level?.name, message: tutorialString, preferredStyle: UIAlertControllerStyle.alert)
			//alert.addAction(UIAlertAction(title: "Start level", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.drumPlayer.volume = 1}))
			//self.present(alert, animated: true, completion: nil)
			let tText = LevelTutorialViewController()
			tText.tutorialText = tutorialString
			tText.modalPresentationStyle = .formSheet
			tText.modalTransitionStyle = .coverVertical
			tText.myParent = self
			if let background = (level?.background) as String? {
				tText.background = background
			}
			self.present(tText, animated: true, completion: {
				//self.drumPlayer.volume = 1
			})
			//self.showDetailViewController(tText, sender: self)
			
		}
		
		
		//adding the grid to the gamescene in scenekit
		ButtonView.gameControllerView = self
		ButtonView.backgroundColor = UIColor(red: 27.0/256.0, green: 40.0/256.0, blue: 54.0/256.0, alpha: 1.0)
		let skView = SKView(frame: view.bounds)
		skView.isUserInteractionEnabled = false
		skView.allowsTransparency = true
		self.view.addSubview(skView)
		self.scene = GameScene(size: view.bounds.size)
		scene?.playerPosition = playerLoc
		skView.presentScene(scene)
		
		self.cmdHandler = CommandHandler(level: &tileArray, playerLoc: &playerLoc, goalLoc: &goalLoc, myGameScene: self.scene!)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//reset everything
	override func tapReset(_ sender: UITapGestureRecognizer) {
		if (takeInput) {
			resetLevelState()
		}
	}
	
	//change everything to default values
	override func resetLevelState() {
		scene?.setPlayerPos(newPos: level!.startingLoc)
		cmdHandler?.setPlayerLoc(newCoords: level!.startingLoc)
		cmdHandler?.resetGoal(coords: level!.goalLoc)
		cmdHandler?.onGoal = false
		
		//rebuild things that were destroyed or collected (I don't know why the previous team did it this way!!!)
		for cell in breakBlocks {
			cell.makeWall()
		}
		for cell in fuelCells {
			cell.makeFuel()
		}
	}
	
	/**
	Gets button input from the Input controller
	
	- parameter type: (To be) enum specifying type of button
	
	**/
	
	// TODO: Rewrite this function as a switch over ButtonTypes
	//^^^ this would make this code even harder to read, I think
	override func getButtonInput(type:ButtonType) {
		//if the commands are not being played through atm
		if (takeInput) {
			if (type.rawValue < 5 && commandQueue.count < 28) { // If command is to be added to queue and queue is not full
				
				
				//queues up this command, adds accessibility, etc.
				let tempCell = UIImageView(image: UIImage(named:imageNames[type.rawValue] + ".png"))
				tempCell.frame = CGRect(x: LevelViewController.scaleDims(input: (70*commandQueue.count) % 980, x: true), y: LevelViewController.scaleDims(input: 526 + 70*(commandQueue.count/14), x: false), width: LevelViewController.scaleDims(input:64, x: true), height: LevelViewController.scaleDims(input: 64, x: false))
				tempCell.isAccessibilityElement = true
				tempCell.accessibilityTraits = UIAccessibilityTraitImage
				tempCell.accessibilityLabel = imageNames[type.rawValue]
				
				if (type.rawValue == 4) {
					tempCell.accessibilityLabel = "blast"
				}
				
				
				//i think that this was done in order to allow for the scroll gesture in voiceover
				self.view.addSubview(tempCell)
				
				commandQueue.append(type.rawValue)
				commandQueueViews.append(tempCell)
				playSound(sound: commandSounds[type.rawValue])
			} else if(type.rawValue < 5 && commandQueue.count >= 28) { //the queue is full
				
				playSound(sound: failSound);
				let delayTime = DispatchTime.now() + .milliseconds(300)
				DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
					UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, "Command queue full");
				})
				
				
				
			} else { // Command is to be executed immediately, deals with buttons that are not commands for the player (erase, queue, etc)
				if (type == ButtonType.ERASE1) {
					commandQueueViews.popLast()?.removeFromSuperview()
					commandQueue.popLast()
				} else if (type == ButtonType.ERASEALL) {
					resetLevelState()
					for view in commandQueueViews {
						view.removeFromSuperview()
					}
					commandQueueViews.removeAll()
					commandQueue.removeAll()
				} else if (type == ButtonType.QUEUESOUND) {
					takeInput = false
					currentStep = 0
					tickTimer = Timer.scheduledTimer(timeInterval: 0.25, target:self,
					                                 selector:#selector(LevelViewController.runQueueSounds),
					                                 userInfo:nil, repeats: true)
				}
			}
		}
	}
	
	/// Action for Play Button
	@IBAction override func PlayButton(_ sender: UIButton) {
		if (takeInput) {
			// Don't take input while commands are running
			takeInput = false
			
			
			//this is done because if the previous attempt was not successful, we don't want the previously broken blocks and other things to remain!
			resetLevelState()
			
			currentStep = 0
			//			won = false
			
			//i believe that this limits the time for the player to do 1 action
			tickTimer = Timer.scheduledTimer(timeInterval: 0.4054, target:self, selector:#selector(LevelViewController.runCommands), userInfo:nil, repeats: true)
		}
	}
	
	/// Executes one step of the game loop
	override func runCommands() {
		musicPlayer.volume = 0.1 * musicVolume
		
		var moved = false
		
		//i guess that this animates the button that represents the current action?
		if (currentStep != 0 && !aboutToWin) {
			commandQueueViews[currentStep-1].frame.origin.y += 10
		}
		
		//handles a basic command
		if currentStep < commandQueue.count && !aboutToWin {
			if (currentStep < (commandQueue.count - 1)) {
				commandQueueViews[currentStep].frame.origin.y -= 10
			}
			//			var maybewon: Bool
			//			(moved, maybewon) = (cmdHandler?.handleCmd(input: commandQueue[currentStep]))!
			(moved, onShip) = (cmdHandler?.handleCmd(input: commandQueue[currentStep]))!
			//			won = won || maybewon
			if (moved) {
				scene?.movePlayer(newPos: (cmdHandler?.playerLoc)!)
			} else if commandQueue[currentStep] < 4{
				//not really sure what this does...
				scene?.tryToMoveTo(newPos: (cmdHandler?.newCoordsFromCommand(input: commandQueue[currentStep]))!)
			}
			
		}
		
		currentStep += 1
		
		//handles the last command in the sequence if it is not a winning command
		if currentStep >= commandQueue.count && !aboutToWin{
			
			// All commands run, ready to take input again
			
			
			let won = checkWin()
			
			if (won) {
				aboutToWin = true
				return
			} else {
				musicPlayer.volume = 1.0 * musicVolume
			}
			tickTimer.invalidate()
			takeInput = true
		}
		
		//this variable is not appropriately named or could be named a bit better. it is basically only true when the player is on the ship and has done all of the requirements. so they basically HAVE won already, but now we will process what will happen once they win
		if aboutToWin {
			musicPlayer.volume = 1.0 * musicVolume
			playSound(sound: cheerSound)
			
			//handles the scoreboard...we should add to this to make the scoreboard more dynamic
			if !level!.cleared {
				level!.cleared = true
				level!.highscore = commandQueue.count
			} else if commandQueue.count < level!.highscore {
				level!.highscore = commandQueue.count
			}
			
			//alert...not sure if it is voiceover friendly or not
			let alert = UIAlertController(title: "You win!", message: "You took \(commandQueue.count) steps. Your best score is \(level!.highscore).", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Yay!", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.musicPlayer.volume = 1.0 * musicVolume}))
			self.present(alert, animated: true, completion: nil)
			
			//updates the level selection screen, since the viewcontrollers are currently in a pop/push queue
			if let selectedIndexPath = parentLevelTableViewController?.tableView.indexPathForSelectedRow{
				parentLevelTableViewController?.levels[selectedIndexPath.row] = level!
				parentLevelTableViewController?.saveLevels()
				parentLevelTableViewController?.tableView.reloadRows(at: [selectedIndexPath], with:.none)
			}
			aboutToWin = false
			tickTimer.invalidate()
			takeInput = true
		}
		
		
	}
	
	override func win() {
		
	}
	
	//checks win conditions. we should add to this if we want more win requirements
	override func checkWin() -> Bool {
		// All fuel cells must be collected
		var gotFuel : Bool = true
		for cell in fuelCells {
			if (cell.isFuel) {
				gotFuel = false
			}
		}
		return gotFuel && onShip
	}
	
	override func viewWillDisappear(_ animated : Bool) {
		super.viewWillDisappear(animated)
		musicPlayer.stop()
		drumPlayer.stop()
	}
	
	// Plays the sound associated with the command in commandQueue[currentStep]
	// Note that commands and queue sounds will never be running at the same time, so it
	// should be safe to reuse tickTimer and currentStep here
	override func runQueueSounds() {
		if (currentStep < commandQueue.count) {
			playSound(sound: commandSounds[commandQueue[currentStep]])
			currentStep += 1
		} else {
			tickTimer.invalidate()
			takeInput = true
		}
	}
	
}

