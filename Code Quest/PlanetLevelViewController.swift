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

let testImageNames = ["left", "up", "down", "right", "blast_button"]
let testCommandSounds = [leftSound, rightSound, upSound, downSound, blastSound]

/// Primary game controller. Contains most game state information
class PlanetLevelViewController: DevLevelViewController {
	
	var devParentLevelTableViewController : Planet1ViewController? = nil
	var devCmdHandler: DevCommandHandler? = nil
	
	var sceneColor = UIColor(red: 17.0/256.0, green: 132.0/256.0, blue: 99.0/256.0, alpha: 1.0)
    
    var planetNumber = 0
    var levelNumber:Int = 0
    var bestScore=0;
	var numOfLoopsPerLoop : [Int] = []
	var loopCommands : [Int] = []
	var loopIndex=0
	var realCommandQueue: [Int] = []
	var loopRanges:[(Int,Int)]=[]
	var currentIndexCorrected=0
	var currentLoopRange=0
	var totalNumOfLoops=0
	var loopLabels:[UILabel]=[]
	var layoutText:String = ""
	
	/// Controls game logic
	override func viewDidLoad() {
		
		self.view.backgroundColor = sceneColor
		
		//super.viewDidLoad() //this breaks it for some reason
		
		self.navigationItem.title = "Level "+String(planetNumber)+"-"+String(levelNumber)
        self.navigationItem.accessibilityLabel="Level "+String(planetNumber)+"-"+String(levelNumber)
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Best Score = " + String(bestScore), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem?.isEnabled=false
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
			//drumPlayer.play(atTime: now+sdelay)
		} catch {
			print ("music failed")
		}
		
		
		//allows for tap input
		let touchOnResetRecognizer = UITapGestureRecognizer(target: self, action: #selector (self.tapReset (_:)))
		self.view.addGestureRecognizer(touchOnResetRecognizer)
		//print(level?.data)
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
			let tText = DevLevelTutorialViewController()
			tText.tutorialText = tutorialString
			tText.layoutText=layoutText
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
		ButtonView.backgroundColor = sceneColor
		let skView = SKView(frame: view.bounds)
		skView.isUserInteractionEnabled = false
		skView.allowsTransparency = true
		self.view.addSubview(skView)
		self.scene = DevGameScene(size: view.bounds.size)
		scene?.playerPosition = playerLoc
		skView.presentScene(scene)
		
		self.cmdHandler = CommandHandler(level: &tileArray, playerLoc: &playerLoc, goalLoc: &goalLoc, myGameScene: self.scene!)
		
		//super.viewDidLoad()
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
				let tempCell = UIImageView(image: UIImage(named:testImageNames[type.rawValue] + ".png"))
				//tempCell.frame = CGRect(x: LevelViewController.scaleDims(input: (70*commandQueue.count) % 980, x: true), y: LevelViewController.scaleDims(input: 526 + 70*(commandQueue.count/14), x: false), width: LevelViewController.scaleDims(input:64, x: true), height: LevelViewController.scaleDims(input: 64, x: false))
				tempCell.isAccessibilityElement = true
				tempCell.accessibilityTraits = UIAccessibilityTraitImage
				//tempCell.accessibilityTraits = UIAccessibilityTraitNone
				tempCell.accessibilityLabel = testImageNames[type.rawValue]
				
				if (type.rawValue == 4) {
					tempCell.accessibilityLabel = "blast"
				}
				
				
				//i think that this was done in order to allow for the scroll gesture in voiceover
				self.view.addSubview(tempCell)
				
				commandQueue.append(type.rawValue)
				commandQueueViews.append(tempCell)
				realCommandQueue.append(type.rawValue)
				playSound(sound: testCommandSounds[type.rawValue])
			} else if(type.rawValue < 5 && commandQueue.count >= 28) { //the queue is full
				
				playSound(sound: failSound);
				let delayTime = DispatchTime.now() + .milliseconds(300)
				DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
					UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, "Command queue full");
				})
				
				
				
			} else if type.rawValue == 8 {
				print("loop pressed")
				print("real queue before="+String(realCommandQueue.count))
				if (commandQueue.count > 0) {
					if (commandQueue[commandQueue.count-1] != 8){
						let commandToLoop = commandQueue[commandQueue.count-1]
						print("loop "+testImageNames[commandToLoop])
						
						var doneCountingLoops=false
						var index = commandQueue.count-2
						var numOfLoops=1
						
						while (!doneCountingLoops){
							if index >= 0{
								if (commandQueue[index] == commandToLoop){
									numOfLoops += 1
								}
								else{
									doneCountingLoops=true
								}
								index -= 1
							}
							else{
								doneCountingLoops=true
							}
						}
						print("num of loops="+String(numOfLoops))
						
						var i = 0
						print("real queue before="+String(realCommandQueue.count))
						for i in 0...numOfLoops-1 {
							print("pop view")
							commandQueueViews.popLast()?.removeFromSuperview()
							commandQueue.popLast()
							//realCommandQueue.append(commandToLoop)
						}
						print("real queue after="+String(realCommandQueue.count))
						let tempCell = UIImageView(image: UIImage(named:testImageNames[commandToLoop] + ".png"))
						tempCell.frame = CGRect(x: LevelViewController.scaleDims(input: (70*commandQueue.count) % 980, x: true), y: LevelViewController.scaleDims(input: 526 + 70*(commandQueue.count/14), x: false), width: LevelViewController.scaleDims(input:64, x: true), height: LevelViewController.scaleDims(input: 64, x: false))
						tempCell.isAccessibilityElement = true
						tempCell.accessibilityTraits = UIAccessibilityTraitImage
						//tempCell.accessibilityTraits = UIAccessibilityTraitNone
						tempCell.accessibilityLabel = "Loop "+testImageNames[commandToLoop]+" "+String(numOfLoops)+" times"
						
						self.view.addSubview(tempCell)
						
						
						var loopLabel=UILabel(frame: CGRect(x: LevelViewController.scaleDims(input: (70*commandQueue.count) % 980, x: true), y: LevelViewController.scaleDims(input: 526 + 70*(commandQueue.count/14), x: false), width: LevelViewController.scaleDims(input:64, x: true), height: LevelViewController.scaleDims(input: 64, x: false)))
						loopLabel.textAlignment = .center
						loopLabel.text=String(numOfLoops)
						loopLabel.font = loopLabel.font.withSize(60)
						loopLabel.accessibilityLabel = "Loop "+testImageNames[commandToLoop]+" "+String(numOfLoops)+" times"
						self.view.addSubview(loopLabel)
						loopLabels.append(loopLabel)
						
						commandQueue.append(type.rawValue)
						//realCommandQueue.append(type.rawValue)
						commandQueueViews.append(tempCell)
						playSound(sound: testCommandSounds[commandToLoop])
						numOfLoopsPerLoop.append(numOfLoops)
						loopCommands.append(commandToLoop)
						loopRanges.append((realCommandQueue.count-numOfLoops,realCommandQueue.count-1))
						totalNumOfLoops += 1
						print(numOfLoopsPerLoop[numOfLoopsPerLoop.count-1])
						print(loopCommands[loopCommands.count-1])
						print(loopRanges)
					}
				}
				else{
					print("nothing to loop")
				}
			}
			
			else { // Command is to be executed immediately, deals with buttons that are not commands for the player (erase, queue, etc)
				if (type == ButtonType.ERASE1) {
					printStatus()
					commandQueueViews.popLast()?.removeFromSuperview()
					commandQueue.popLast()
					
					//IMPORTANT NOTE: loopRanges is based on realCommandQueue, not commandQueue
					if (loopRanges.count != 0){
						//print("there's a loop")
						//print("command queue size="+String(realCommandQueue.count))
						//print("last loopRange index last="+String(loopRanges[loopRanges.count-1].1))
						
						if (realCommandQueue.count-1 == loopRanges[loopRanges.count-1].1){
							print("removing a loop")
							let numOfLoopsForLastCommand=numOfLoopsPerLoop[numOfLoopsPerLoop.count-1]
							//print("before erase"+String(describing: realCommandQueue))
							for i in 0...numOfLoopsForLastCommand-1 {
								realCommandQueue.popLast()
							}
							loopRanges.popLast()
							loopLabels[loopLabels.count-1].removeFromSuperview()
							loopLabels.popLast()
							numOfLoopsPerLoop.popLast()
							//print("after erase"+String(describing: realCommandQueue))
							loopCommands.popLast()
							totalNumOfLoops -= 1
							printStatus()
						}
						else{
							realCommandQueue.popLast()
						}
					}
					else{
						realCommandQueue.popLast()
					}
					
					
					
				} else if (type == ButtonType.ERASEALL) {
					resetLevelState()
					for view in commandQueueViews {
						view.removeFromSuperview()
					}
					for view in loopLabels{
						view.removeFromSuperview()
					}
					commandQueueViews.removeAll()
					commandQueue.removeAll()
					realCommandQueue.removeAll()
					loopRanges.removeAll()
					loopLabels.removeAll()
					numOfLoopsPerLoop.removeAll()
					loopCommands.removeAll()
					
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
			loopIndex=0
			currentIndexCorrected=0
			currentLoopRange=0
			//			won = false
			
			//i believe that this limits the time for the player to do 1 action
			//interval was 0.4054
			print("real count="+String(realCommandQueue.count))
			tickTimer = Timer.scheduledTimer(timeInterval: 0.4054, target:self, selector:#selector(LevelViewController.runCommands), userInfo:nil, repeats: true)
		}
	}
	
	/// Executes one step of the game loop
	override func runCommands() {
		musicPlayer.volume = 0.1 * musicVolume
		print("current step="+String(currentStep))
		print("correctedIndex="+String(currentIndexCorrected))
		print(realCommandQueue)
		var moved = false
		//var loopIndex=0
		
		//i guess that this animates the button that represents the current action?
		if (currentIndexCorrected != 0 && !aboutToWin) {
			//+y is downwards, so this moves the previous tile back down
			//BUG: we need to borrow the below loop-detection logic to make sure we don't move the same block multiple times
			print("1")
			printStatus()
			print("2")
			if loopRanges.count != 0 && currentLoopRange<totalNumOfLoops {
				print("3")
				if (currentStep==loopRanges[currentLoopRange].0){
					print("beginning of loop. move up")
					commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
					loopLabels[currentLoopRange-1].frame.origin.y += 10
				}
				
			}
			else if (loopRanges.count != 0 && currentStep-1 == loopRanges[loopRanges.count-1].1){
				//the previous one was a loop and this one is not a loop. will still need to bring the loop's number down
				print("previous tile is loop")
				commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
				loopLabels[loopLabels.count-1].frame.origin.y += 10
			}
			else{
				//there are no loops at all
				print("no loops")
				//currentIndexCorrected += 1
				commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
				//loopLabels[currentLoopRange].frame.origin.y += 10
			}
			
			//commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
		}
		
		//handles a basic command
		if currentStep < realCommandQueue.count && !aboutToWin {
			if (currentIndexCorrected < (commandQueue.count - 1)) {
				//if (currentStep < (commandQueue.count - 1)) {
				if loopRanges.count != 0 && currentLoopRange<totalNumOfLoops {
					if (currentStep==loopRanges[currentLoopRange].0){
						print("beginning of loop. move up")
						commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
						loopLabels[currentLoopRange].frame.origin.y -= 10
					}
					
				}
				else{
					//there are no loops at all
					print("no loops")
					//currentIndexCorrected += 1
					commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
				}
				
				//commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
			}
			//			var maybewon: Bool
			//			(moved, maybewon) = (cmdHandler?.handleCmd(input: commandQueue[currentStep]))!
			
			if (realCommandQueue[currentStep] != 8){
				(moved, onShip) = (cmdHandler?.handleCmd(input: realCommandQueue[currentStep]))!
				//(moved, onShip) = (cmdHandler?.handleCmd(input: commandQueue[currentStep]))!
			}
			else{
				//DEPRACATED...too many visual artifacts
				print("this should not happen")
				print("starting loop")
				let commandToPlay=loopCommands[loopCommands.count-loopIndex-1]
				let numOfLoopsToPlay=numOfLoopsPerLoop[numOfLoopsPerLoop.count-loopIndex-1]
				print("process loop "+String(commandToPlay) + "___" + String(numOfLoopsToPlay))
				
				(moved, onShip) = (cmdHandler?.handleLoop(commandToLoop: commandToPlay, numOfLoops: numOfLoopsToPlay))!
				loopIndex += 1
				print("done")
			}
			
			//			won = won || maybewon
			if (moved) {
				scene?.movePlayer(newPos: (cmdHandler?.playerLoc)!)
			} else if realCommandQueue[currentStep] < 4{
				//not really sure what this does...
				if (realCommandQueue[currentStep] != 8){
				scene?.tryToMoveTo(newPos: (cmdHandler?.newCoordsFromCommand(input: realCommandQueue[currentStep]))!)
				}
				else{
					print("trying to move")
				}
			}
			
		}
		
		if loopRanges.count != 0 && currentLoopRange<totalNumOfLoops {
			print("4")
			if (currentStep>=loopRanges[currentLoopRange].0 && currentStep<loopRanges[currentLoopRange].1){
				//don't update currentIndexCorrected...we're in a loop
				print("5")
			}
			else if (currentStep==loopRanges[currentLoopRange].1){
				//ended the loop. time to move on
				print("ended loop")
				currentLoopRange += 1
				currentIndexCorrected += 1
			}
			else {
				//not in a loop
				print("7")
				currentIndexCorrected += 1
			}
		}
		else{
			//there are no loops at all
			print("no loops")
			currentIndexCorrected += 1
		}
		print("6")
		currentStep += 1
		
		//handles the last command in the sequence if it is not a winning command
		//note that the player can move past the ship without winning
		if currentStep >= realCommandQueue.count && !aboutToWin{
			
			// All commands run, ready to take input again
			
			print("checkWin")
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
			//if let selectedIndexPath = parentLevelTableViewController?.tableView.indexPathForSelectedRow{
				//devParentLevelTableViewController?.levels[selectedIndexPath.row] = level!
			//BUG: update parent controller's labels
				devParentLevelTableViewController?.saveLevels()
				//parentLevelTableViewController?.tableView.reloadRows(at: [selectedIndexPath], with:.none)
			//}
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
			playSound(sound: testCommandSounds[commandQueue[currentStep]])
			currentStep += 1
		} else {
			tickTimer.invalidate()
			takeInput = true
		}
	}
	
	func printStatus(){
		print("__________________________START__________________________")
		print("command queue views: "+String(describing: commandQueueViews))
		print("command queue: "+String(describing: commandQueue))
		print("real command queue: "+String(describing: realCommandQueue))
		print("loop ranges: "+String(describing: loopRanges))
		print("loop labels: "+String(describing: loopLabels))
		print("numofloopsperloop: "+String(describing: numOfLoopsPerLoop))
		print("loopcommands: "+String(describing: loopCommands))
		print("__________________________END____________________________")
	}
	
}

