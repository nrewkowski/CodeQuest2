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
class PlanetLevelViewController: LevelViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {
	@available(iOS 2.0, *)
	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

	
	var parentPlanetViewController : PlanetViewController? = nil
	var devCmdHandler: CommandHandler? = nil
	
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
	var pickerData = ["2","3","4","5"]
	
	var isFirstViewControllerOnStack = true
	
	var levels = [Level]()
	var levelsToUse:[Int]=[]
	
	var hint: String = ""
	
	var penalties = -1
	
	var failed = false
	
	var selectedNumOfLoops = 2 //default to 2 or else crash
	var currentLoopLabel = -1
	
	let speechSynthesizer = AVSpeechSynthesizer()
	var myUtterance = AVSpeechUtterance(string: "")
	
	var originalSpeechSynthesizer = AVSpeechSynthesizer()
	
	var movedLastStep = true
	
	
	/// Controls game logic
	override func viewDidLoad() {
		
		if (!isFirstViewControllerOnStack){
			var navArray = self.navigationController?.viewControllers
			navArray?.remove(at: (navArray?.count)! - 2)
			self.navigationController?.viewControllers = navArray!
			isFirstViewControllerOnStack = true
		}
		
		self.view.backgroundColor = sceneColor
		
		//super.viewDidLoad() //this breaks it for some reason
		
		self.navigationItem.title = "Level "+String(planetNumber)+"-"+String(levelNumber+1)
        self.navigationItem.accessibilityLabel="Level "+String(planetNumber)+"-"+String(levelNumber+1)
        var scoreButton=UIBarButtonItem(title: "Best Score = " + String(bestScore), style: .plain, target: nil, action: nil)
        scoreButton.tintColor = UIColor.black
        scoreButton.isEnabled=false
		
		var penaltyButton=UIBarButtonItem(title: "Penalties = " + String(0), style: .plain, target: nil, action: nil)
		penaltyButton.tintColor = UIColor.black
		penaltyButton.isEnabled=false
		self.navigationItem.rightBarButtonItems = [scoreButton, penaltyButton]
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
					//NOTE: add more cases for more wall types
					//NOTE: alter voiceover for row, column here
					switch testGrid[y][x] {      //Instantiate gameCells based on input array
					case 1:
						cell = floorCell(isWall: false, isFuel: false,row: y+1, column: x+1)
					case 2:
						cell = wallCell(row: y+1, column: x+1)
					case 3:
						cell = BreakableWallCell(initialHealth: 1,row: y+1, column: x+1)
						breakBlocks.append(cell as! BreakableWallCell)
					case 4:
						cell = floorCell(isWall: false, isFuel: true,row: y+1, column: x+1)
						if (planetNumber == 2) {
							cell.image = UIImage(named: "alien2tile")
						}
						else if (planetNumber == 3) {
							cell.image = UIImage(named: "alien3tile")
						}
						fuelCells.append(cell as! floorCell)
					case 5:
						cell = BreakableWallCell(initialHealth: 1,row: y+1, column: x+1)
						breakBlocks.append(cell as! BreakableWallCell)
					case 6:
						cell = BreakableWallCell(initialHealth: 2,row: y+1, column: x+1)
						breakBlocks.append(cell as! BreakableWallCell)
					case 7:
						cell = BreakableWallCell(initialHealth: 3,row: y+1, column: x+1)
						breakBlocks.append(cell as! BreakableWallCell)
					case 8:
						cell = BreakableWallCell(initialHealth: 4,row: y+1, column: x+1)
						breakBlocks.append(cell as! BreakableWallCell)
					case 9:
						cell = BreakableWallCell(initialHealth: 5,row: y+1, column: x+1)
						breakBlocks.append(cell as! BreakableWallCell)
					default:
						cell = floorCell(isWall: false, isFuel: false,row: y+1, column: x+1)
					}
					
					if x==0 && y==0 {
						//cell.image = UIImage(named: "greentile")
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
			
			if let firstTile = tileArray[0][0] as? floorCell {
				firstTile.image = UIImage(named: "greentile")
			}
		}
		
		
		//populates the string that is read in the beginning of the level
		if let tutorialString = (level?.tutorialText)! as String? {
			//let alert = UIAlertController(title: level?.name, message: tutorialString, preferredStyle: UIAlertControllerStyle.alert)
			//alert.addAction(UIAlertAction(title: "Start level", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.drumPlayer.volume = 1}))
			//self.present(alert, animated: true, completion: nil)
			let tText = LevelTutorialViewController()
			tText.tutorialText = tutorialString
			tText.layoutText=layoutText
			tText.modalPresentationStyle = .formSheet
			tText.modalTransitionStyle = .coverVertical
			tText.myParent = self
			tText.speechSynthesizer = originalSpeechSynthesizer
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
		ButtonView.pickerView?.delegate=self
		ButtonView.pickerView?.dataSource=self
		
		ButtonView.planetNumber = planetNumber
		
		if (planetNumber<5){
			ButtonView.loopButton?.isEnabled=false
			ButtonView.loopButton?.isAccessibilityElement=false
			ButtonView.pickerView?.isHidden = true
			ButtonView.pickerView?.isAccessibilityElement=false
		}
		if (planetNumber<3){
			ButtonView.blastButton?.isEnabled=false
			ButtonView.blastButton?.isAccessibilityElement=false
		}
		
		let skView = SKView(frame: view.bounds)
		skView.isUserInteractionEnabled = false
		skView.allowsTransparency = true
		self.view.addSubview(skView)
		self.scene = DevGameScene(size: view.bounds.size)
		scene?.playerPosition = playerLoc
		skView.presentScene(scene)
		
		self.cmdHandler = CommandHandler(level: &tileArray, playerLoc: &playerLoc, goalLoc: &goalLoc, myGameScene: self.scene!)
		print("par: "+String((level?.parNumMoves)! as Int))
		print("stars: "+String((level?.starsGotten)! as Int))
		print("stars: "+String(describing: level?.numOfMovesRequiredPerStar))
		
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.loopTapped(recognizer:)))
		tap.numberOfTapsRequired = 1
		ButtonView.pickerView?.addGestureRecognizer(tap)
		tap.delegate = self
		//let touchOnLoopRecognizer = UITapGestureRecognizer(target: self, action: #selector (self.loopTapped(recognizer:)))
		//self.view.addGestureRecognizer(touchOnLoopRecognizer)
		
		//print("par: "+String(describing: level?.parNumMoves))
		//print("stars: "+String(describing: level?.starsGotten))
		//super.viewDidLoad()
	}
	
	
	
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerData.count
	}
	
//	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//		return pickerData[row]
//	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		var pickerLabel : UILabel
		if let label = view as? UILabel {
			pickerLabel = label
		} else {
			pickerLabel = UILabel()
			pickerLabel.textColor = UIColor.black
			pickerLabel.textAlignment = NSTextAlignment.center
		}
		
		pickerLabel.text = pickerData[row]
		pickerLabel.sizeToFit()
		pickerLabel.accessibilityLabel = "Loop "+String(pickerData[row])+" times."
		return pickerLabel
	}
	
	
	func loopTapped(recognizer: UITapGestureRecognizer){
		print("tapped")
		print("loop pressed")
		print("real queue before="+String(realCommandQueue.count))
		
		var numOfLoops:Int = selectedNumOfLoops
		if (commandQueue.count > 0) {
			if (commandQueue[commandQueue.count-1] != 8){
				print("4.1")
				let commandToLoop = commandQueue[commandQueue.count-1]
				print("loop "+testImageNames[commandToLoop])
				
				var doneCountingLoops=false
				var index = commandQueue.count-2
				//var numOfLoops=1
				
				/*
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
				}*/
				print("num of loops="+String(numOfLoops))
				
				var i = 0
				print("real queue before="+String(realCommandQueue.count))
				commandQueueViews.popLast()?.removeFromSuperview()
				commandQueue.popLast()
				realCommandQueue.popLast()
				print("4.2")
				for i in 0...numOfLoops-1 {
					print("append")
					//commandQueue.append(commandToLoop)
					realCommandQueue.append(commandToLoop)
				}
				
				/*
				
				commandQueue.append(type.rawValue)
				commandQueueViews.append(tempCell)
				realCommandQueue.append(type.rawValue)
				*/
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
				
				
				commandQueue.append(8)
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
				print(totalNumOfLoops)
			}
		}
		else{
			print("nothing to loop")
		}

	}
	
 
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		/*
		let alertController = UIAlertController(title: "Error", message: pickerData[row], preferredStyle: UIAlertControllerStyle.alert)
		alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
		self.present(alertController, animated: true, completion: nil)*/
		//myLabel.text = pickerData[row]
		print("row select")
		selectedNumOfLoops = Int(pickerData[row])!
		//pickerView.row
		

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
			if (planetNumber == 2) {
				cell.image = UIImage(named: "alien2tile")
			}
			else if (planetNumber == 3) {
				cell.image = UIImage(named: "alien3tile")
			}
		}
		
		penalties += 1
		
		var scoreButton=UIBarButtonItem(title: "Best Score = " + String(bestScore), style: .plain, target: nil, action: nil)
		scoreButton.tintColor = UIColor.black
		scoreButton.isEnabled=false
		
		var penaltyButton=UIBarButtonItem(title: "Penalties = " + String(penalties), style: .plain, target: nil, action: nil)
		penaltyButton.tintColor = UIColor.black
		penaltyButton.isEnabled=false
		self.navigationItem.rightBarButtonItems = [scoreButton, penaltyButton]
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
				tempCell.frame = CGRect(x: LevelViewController.scaleDims(input: (70*commandQueue.count) % 980, x: true), y: LevelViewController.scaleDims(input: 526 + 70*(commandQueue.count/14), x: false), width: LevelViewController.scaleDims(input:64, x: true), height: LevelViewController.scaleDims(input: 64, x: false))
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
				
				
			}

			else if type.rawValue == 9 {
			
				print("help")
				originalSpeechSynthesizer.stopSpeaking(at: .immediate)
				speechSynthesizer.stopSpeaking(at: .immediate)
				myUtterance = AVSpeechUtterance(string: layoutText+","+hint)
				myUtterance.rate = 0.5 //make this a slider like volume
				speechSynthesizer.speak(myUtterance)
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
					totalNumOfLoops = 0
					
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
			currentLoopLabel=0
			movedLastStep = true
			//			won = false
			
			//i believe that this limits the time for the player to do 1 action
			//interval was 0.4054
			print("real count="+String(realCommandQueue.count))
			tickTimer = Timer.scheduledTimer(timeInterval: 0.4054, target:self, selector:#selector(LevelViewController.runCommands), userInfo:nil, repeats: true)
			return
		}
	}
	
	/// Executes one step of the game loop
	override func runCommands() {
		musicPlayer.volume = 0.1 * musicVolume
		
		if (!movedLastStep){
			print(commandQueue.count)
			print(currentIndexCorrected)
			if (currentIndexCorrected != commandQueue.count-1){ //if this is not the last step
				print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
				if (commandQueue[currentIndexCorrected] == 8){
					commandQueueViews[currentIndexCorrected].frame.origin.y += 10
					loopLabels[currentLoopLabel].frame.origin.y += 10
				}
				else{
					commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
				}
			}
			else{
				print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
				if (commandQueue[currentIndexCorrected] == 8){
					if (currentStep == loopRanges[loopRanges.count-1].0) {
						commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
					}
					else{
						//commandQueueViews[currentIndexCorrected].frame.origin.y += 10
					}
				}
				else{
					commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
				}
			}
			
			musicPlayer.volume = 1.0 * musicVolume
			tickTimer.invalidate()
			takeInput = true
			
			return
		}
		print("current step="+String(currentStep))
		print("correctedIndex="+String(currentIndexCorrected))
		print(realCommandQueue)
		var moved = false
		//var loopIndex=0
		
		//i guess that this animates the button that represents the current action?
		if (currentIndexCorrected != 0 && !aboutToWin) {


			print("right1")
			if (currentIndexCorrected > 0){//if there is a previous tile
				//+y is downwards, so this moves the previous tile back down
				/*			cases. all must be handled individually to prevent crashes
				1. loop->...->loop->loop. current tile is a loop, previous tile is a loop, more loops prior to that
				2. loop->...->loop->noloop current tile is not a loop, previous tile is loop, more loops prior
				3. loop->...->noloop->loop current tile is loop, previous is not, loops prior to that
				4. 1 loop->...->noloop->noloop current tile not a loop, previous not a loop, loops prior (easy case)
				5. noloop->...->loop->loop current is loop, previous is loop, no previous loops
				6. noloop->...->loop->noloop current is not a loop, previous is, none prior (easy case)
				7. noloop->...->noloop->loop current is loop, previous is not, no loops prior (easy case)
				8. noloop->...->noloop->noloop no loops at all (easiest case)
				9. >1 loop->...->noloop->noloop. modified case 4
				
				for all cases in which current tile is loop, must also test condition that current step is at the beginning of loop, otherwise, don't move last tile down
				handle no loop situation, then situations in which there is only 1 loop
				IMPORTANT ASSUMPTION: if the previous tile is 8, then its index in loopranges is the last one
				
*/
				print("VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV")
				if (totalNumOfLoops == 0){
					print("case 8")
					
					commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
					if (currentIndexCorrected != commandQueue.count-1){
						commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
					}
				}
				else if (totalNumOfLoops == 1){
					print("case 7,6, or 4")
					if (commandQueue[currentIndexCorrected]==8){
						print("case 7. current loop is only one")
						if (currentStep == loopRanges[0].0){
							print("beginning of loop")
							commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
							if (currentIndexCorrected != commandQueue.count-1){
								commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
								loopLabels[0].frame.origin.y -= 10
							}
						}
						else{
							print("in loop")
						}
					}
					else if (commandQueue[currentIndexCorrected-1]==8){
						print("case 6. previous tile is only loop")
						commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
						loopLabels[0].frame.origin.y += 10
						if (currentIndexCorrected != commandQueue.count-1){
							commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
						}
					}
					else{
						print("case 4. the 1 loop is somewhere else")
						commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
						if (currentIndexCorrected != commandQueue.count-1){
							commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
						}
					}
				}
				else{
					print("case 1, 2, 3, 5, or 9. more than 1 loop")
					if (commandQueue[currentIndexCorrected]==8){
						print("case 1, 3, or 5. current tile is a loop")
						if (commandQueue[currentIndexCorrected-1]==8){
							print("case 1 or 5 (handled same way). previous tile is also a loop")
							if (currentStep == loopRanges[currentLoopRange].0){
								
								commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
								loopLabels[currentLoopLabel].frame.origin.y += 10
								currentLoopLabel += 1
								if (currentIndexCorrected != commandQueue.count-1){
									commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
									loopLabels[currentLoopLabel].frame.origin.y -= 10
								}
							}
							else{
								print("in a loop")
							}
						}
						else{
							print("case 3. previous is not a loop")
							if (currentStep == loopRanges[currentLoopRange].0){
								
								commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
								
								if (currentIndexCorrected != commandQueue.count-1){
									commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
									loopLabels[currentLoopLabel].frame.origin.y -= 10
								}
							}
							else{
								print("in a loop")
							}

						}
					}
					else{
						print("case 2 or 9. current tile is not a loop. more than 2 loops elsewhere")
						//it is possible that they are in front of current tile...
						//if (currentLoopRange>0){
							//print("still case 2 or 9")
							if (commandQueue[currentIndexCorrected-1]==8){ //currentlooprange-1 because if this is true, then currentlooprange would have been incremented already
								print("case 2. current tile is not a loop, previous one is")
								commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
								loopLabels[currentLoopLabel].frame.origin.y += 10
								currentLoopLabel += 1
								
								if (currentIndexCorrected != commandQueue.count-1){
									commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
								}
							}
							else{
								print("case 9. current tile is not a loop, neither is previous one, but more than 1 loop elsewhere")
								commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
								
								if (currentIndexCorrected != commandQueue.count-1){
									commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
								}
							}

					}
				}
				print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")

			}
		}
		//else if (currentIndexCorrected)
		else if (currentIndexCorrected==0 && commandQueue.count>1){
			print("there is no previous tile but there's a future one.")
			if (totalNumOfLoops>0){
				if (loopRanges[0].0 == 0){
					if (currentStep == 0){
						commandQueueViews[0].frame.origin.y -= 10
						loopLabels[0].frame.origin.y -= 10
					}
				}
				else{
				commandQueueViews[0].frame.origin.y -= 10
				}
			}
			else{
				commandQueueViews[0].frame.origin.y -= 10
			}
		}
		else{
			print("this is the only tile in total. no animation needed")
		}
		
		//handles a basic command
		if currentStep < realCommandQueue.count && !aboutToWin {

			
			if (realCommandQueue[currentStep] != 8){
				(moved, onShip) = (cmdHandler?.handleCmd(input: realCommandQueue[currentStep]))!
				//(moved, onShip) = (cmdHandler?.handleCmd(input: commandQueue[currentStep]))!
				if (realCommandQueue[currentStep] < 4){
					if !moved { //handles what happens when you go out of bounds or hit a wall (moved will be false in these cases)
						movedLastStep = false
//						tickTimer.invalidate()
//						takeInput = true
//						return
					}
				}
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
			//no more loops
			print("____________________________________________________________________________________________________")
			print("no loops anymore")
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
			print("command queue count: "+String(commandQueue.count))
			print(String(describing: level?.numOfMovesRequiredPerStar))
			//handles the scoreboard...we should add to this to make the scoreboard more dynamic
			if !level!.cleared {
				level!.cleared = true
				level!.highscore = commandQueue.count + penalties
				if (level!.highscore <= (level?.numOfMovesRequiredPerStar[2])!){
					level!.starsGotten = 3
				}
				else if (level!.highscore <= (level?.numOfMovesRequiredPerStar[1])!){
					level!.starsGotten = 2
				}
				else{
					level!.starsGotten = 1
				}
				print("stars gotten: "+String(level!.starsGotten))
				
			} else if commandQueue.count < level!.highscore {
				level!.highscore = commandQueue.count + penalties
				var starsGotten=0
				if (level!.highscore <= (level?.numOfMovesRequiredPerStar[2])!){
					starsGotten = 3
				}
				else if (level!.highscore <= (level?.numOfMovesRequiredPerStar[1])!){
					starsGotten = 2
				}
				else{
					starsGotten = 1
				}
				
				if (starsGotten>(level!.starsGotten)){
					level!.starsGotten=starsGotten
				}
				print("stars gotten: "+String(starsGotten))
			}
			else{
				var starsGotten=0
				if (level!.highscore <= (level?.numOfMovesRequiredPerStar[2])!){
					starsGotten = 3
				}
				else if (level!.highscore <= (level?.numOfMovesRequiredPerStar[1])!){
					starsGotten = 2
				}
				else { //if (commandQueue.count <= (level?.numOfMovesRequiredPerStar[0])!)
					starsGotten = 1
				}
				
				if (starsGotten>(level!.starsGotten)){
					level!.starsGotten=starsGotten
				}
				print("stars gotten: "+String(starsGotten))
			
			}
			
			//alert...not sure if it is voiceover friendly or not
			let alert = UIAlertController(title: "You win!", message: "You took \(commandQueue.count) steps. You had \(penalties) penalties. Your best score is \(level!.highscore).", preferredStyle: UIAlertControllerStyle.alert)
			
			var alertTitle=""
			if (levelNumber==2){
				alertTitle="Return to Solar System"
			}
			else{
				alertTitle="Go to Next Level"
			}
			alert.addAction(UIAlertAction(title: alertTitle, style: UIAlertActionStyle.default, handler: goToNextLevel))
			self.present(alert, animated: true, completion: nil)
			
			
			//updates the level selection screen, since the viewcontrollers are currently in a pop/push queue
			//if let selectedIndexPath = parentLevelTableViewController?.tableView.indexPathForSelectedRow{
				//devParentLevelTableViewController?.levels[selectedIndexPath.row] = level!
			//BUG: update parent controller's labels
				parentPlanetViewController?.saveLevels()
				//parentLevelTableViewController?.tableView.reloadRows(at: [selectedIndexPath], with:.none)
			//}
			aboutToWin = false
			tickTimer.invalidate()
			takeInput = true
		}
		
		
	}
	
	func goToNextLevel(alert: UIAlertAction) -> Void{
		print("level num: "+String(levelNumber))
		self.musicPlayer.volume = 1.0 * musicVolume
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		
		if (levelNumber==2){ //last level on planet. go back to planet screen
			//this needs some reimplementation so that too many viewcontrollers don't get pushed onto the stack
			//let vc = storyboard.instantiateViewController(withIdentifier: "Galaxy")
			//self.navigationController?.pushViewController(vc, animated: true)
			self.navigationController?.popViewController(animated: true)
		}
		else{
			let vc = storyboard.instantiateViewController(withIdentifier: "level")
			//pop if current level number is 3, else push new one
			
			let levelViewController = vc as! PlanetLevelViewController
			
			
			levelViewController.planetNumber = planetNumber
			var selectedLevel: Level;
			selectedLevel = levels[levelsToUse[levelNumber+1]]
			var isALevel=true;
			
			if (levelNumber == -1){
				isALevel=false
			}
			else{
				selectedLevel = levels[levelsToUse[levelNumber+1]]
				levelViewController.levelNumber=levelNumber+1
				levelViewController.bestScore=levels[levelsToUse[levelNumber+1]].highscore
			}
			
			if (isALevel) {
				levelViewController.level = selectedLevel
				levelViewController.parentPlanetViewController = parentPlanetViewController
				
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
				//levelViewController.hint=nextLevelHint
				levelViewController.levels=levels
				levelViewController.levelsToUse=levelsToUse
				//we need to add this hint once we decide how to hint system will work
				
				//musicPlayer2.stop()
			}
			
			
			levelViewController.isFirstViewControllerOnStack = false
			self.navigationController?.pushViewController(levelViewController, animated: true)
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
		originalSpeechSynthesizer.stopSpeaking(at: .immediate)
		speechSynthesizer.stopSpeaking(at: .immediate)
		musicPlayer.stop()
		drumPlayer.stop()
	}
	
	// Plays the sound associated with the command in commandQueue[currentStep]
	// Note that commands and queue sounds will never be running at the same time, so it
	// should be safe to reuse tickTimer and currentStep here
	override func runQueueSounds() {
		if (currentStep < realCommandQueue.count) {
			playSound(sound: testCommandSounds[realCommandQueue[currentStep]])
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

/* THE CODE GRAVEYARD
//		print("loop pressed")
//		print("real queue before="+String(realCommandQueue.count))
//		var numOfLoops:Int = Int(pickerData[row])!
//		if (commandQueue.count > 0) {
//			if (commandQueue[commandQueue.count-1] != 8){
//				let commandToLoop = commandQueue[commandQueue.count-1]
//				print("loop "+testImageNames[commandToLoop])
//
//				var doneCountingLoops=false
//				var index = commandQueue.count-2
//				//var numOfLoops=1
//
//				/*
//				while (!doneCountingLoops){
//					if index >= 0{
//						if (commandQueue[index] == commandToLoop){
//							numOfLoops += 1
//						}
//						else{
//							doneCountingLoops=true
//						}
//						index -= 1
//					}
//					else{
//						doneCountingLoops=true
//					}
//				}*/
//				print("num of loops="+String(numOfLoops))
//
//				var i = 0
//				print("real queue before="+String(realCommandQueue.count))
//				commandQueueViews.popLast()?.removeFromSuperview()
//				commandQueue.popLast()
//				realCommandQueue.popLast()
//				for i in 0...numOfLoops-1 {
//					print("pop view")
//					//commandQueue.append(commandToLoop)
//					realCommandQueue.append(commandToLoop)
//				}
//
//				/*
//
//commandQueue.append(type.rawValue)
//commandQueueViews.append(tempCell)
//realCommandQueue.append(type.rawValue)
//*/
//				print("real queue after="+String(realCommandQueue.count))
//				let tempCell = UIImageView(image: UIImage(named:testImageNames[commandToLoop] + ".png"))
//				tempCell.frame = CGRect(x: LevelViewController.scaleDims(input: (70*commandQueue.count) % 980, x: true), y: LevelViewController.scaleDims(input: 526 + 70*(commandQueue.count/14), x: false), width: LevelViewController.scaleDims(input:64, x: true), height: LevelViewController.scaleDims(input: 64, x: false))
//				tempCell.isAccessibilityElement = true
//				tempCell.accessibilityTraits = UIAccessibilityTraitImage
//				//tempCell.accessibilityTraits = UIAccessibilityTraitNone
//				tempCell.accessibilityLabel = "Loop "+testImageNames[commandToLoop]+" "+String(numOfLoops)+" times"
//
//				self.view.addSubview(tempCell)
//
//
//				var loopLabel=UILabel(frame: CGRect(x: LevelViewController.scaleDims(input: (70*commandQueue.count) % 980, x: true), y: LevelViewController.scaleDims(input: 526 + 70*(commandQueue.count/14), x: false), width: LevelViewController.scaleDims(input:64, x: true), height: LevelViewController.scaleDims(input: 64, x: false)))
//				loopLabel.textAlignment = .center
//				loopLabel.text=String(numOfLoops)
//				loopLabel.font = loopLabel.font.withSize(60)
//				loopLabel.accessibilityLabel = "Loop "+testImageNames[commandToLoop]+" "+String(numOfLoops)+" times"
//				self.view.addSubview(loopLabel)
//				loopLabels.append(loopLabel)
//
//
//				commandQueue.append(8)
//				//realCommandQueue.append(type.rawValue)
//				commandQueueViews.append(tempCell)
//				playSound(sound: testCommandSounds[commandToLoop])
//				numOfLoopsPerLoop.append(numOfLoops)
//				loopCommands.append(commandToLoop)
//				loopRanges.append((realCommandQueue.count-numOfLoops,realCommandQueue.count-1))
//				totalNumOfLoops += 1
//
//				print(numOfLoopsPerLoop[numOfLoopsPerLoop.count-1])
//				print(loopCommands[loopCommands.count-1])
//				print(loopRanges)
//				print(totalNumOfLoops)
//			}
//		}
//		else{
//			print("nothing to loop")
//		}

//			 else if type.rawValue == 8 { this is no longer how loops are handled
//				print("loop pressed")
//				print("real queue before="+String(realCommandQueue.count))
//				if (commandQueue.count > 0) {
//					if (commandQueue[commandQueue.count-1] != 8){
//						let commandToLoop = commandQueue[commandQueue.count-1]
//						print("loop "+testImageNames[commandToLoop])
//
//						var doneCountingLoops=false
//						var index = commandQueue.count-2
//						var numOfLoops=1
//
//						while (!doneCountingLoops){
//							if index >= 0{
//								if (commandQueue[index] == commandToLoop){
//									numOfLoops += 1
//								}
//								else{
//									doneCountingLoops=true
//								}
//								index -= 1
//							}
//							else{
//								doneCountingLoops=true
//							}
//						}
//						print("num of loops="+String(numOfLoops))
//
//						var i = 0
//						print("real queue before="+String(realCommandQueue.count))
//						for i in 0...numOfLoops-1 {
//							print("pop view")
//							commandQueueViews.popLast()?.removeFromSuperview()
//							commandQueue.popLast()
//							//realCommandQueue.append(commandToLoop)
//						}
//						print("real queue after="+String(realCommandQueue.count))
//						let tempCell = UIImageView(image: UIImage(named:testImageNames[commandToLoop] + ".png"))
//						tempCell.frame = CGRect(x: LevelViewController.scaleDims(input: (70*commandQueue.count) % 980, x: true), y: LevelViewController.scaleDims(input: 526 + 70*(commandQueue.count/14), x: false), width: LevelViewController.scaleDims(input:64, x: true), height: LevelViewController.scaleDims(input: 64, x: false))
//						tempCell.isAccessibilityElement = true
//						tempCell.accessibilityTraits = UIAccessibilityTraitImage
//						//tempCell.accessibilityTraits = UIAccessibilityTraitNone
//						tempCell.accessibilityLabel = "Loop "+testImageNames[commandToLoop]+" "+String(numOfLoops)+" times"
//
//						self.view.addSubview(tempCell)
//
//
//						var loopLabel=UILabel(frame: CGRect(x: LevelViewController.scaleDims(input: (70*commandQueue.count) % 980, x: true), y: LevelViewController.scaleDims(input: 526 + 70*(commandQueue.count/14), x: false), width: LevelViewController.scaleDims(input:64, x: true), height: LevelViewController.scaleDims(input: 64, x: false)))
//						loopLabel.textAlignment = .center
//						loopLabel.text=String(numOfLoops)
//						loopLabel.font = loopLabel.font.withSize(60)
//						loopLabel.accessibilityLabel = "Loop "+testImageNames[commandToLoop]+" "+String(numOfLoops)+" times"
//						self.view.addSubview(loopLabel)
//						loopLabels.append(loopLabel)
//
//						commandQueue.append(type.rawValue)
//						//realCommandQueue.append(type.rawValue)
//						commandQueueViews.append(tempCell)
//						playSound(sound: testCommandSounds[commandToLoop])
//						numOfLoopsPerLoop.append(numOfLoops)
//						loopCommands.append(commandToLoop)
//						loopRanges.append((realCommandQueue.count-numOfLoops,realCommandQueue.count-1))
//						totalNumOfLoops += 1
//						print(numOfLoopsPerLoop[numOfLoopsPerLoop.count-1])
//						print(loopCommands[loopCommands.count-1])
//						print(loopRanges)
//					}
//				}
//				else{
//					print("nothing to loop")
//				}
//			}


//}
//						else if (currentLoopRange==0) //this case is not possible. currentlooprange could not possibly be 0 if the loop is before this tile.
//						{
//							print("there is only 1 loop before this one, the others are after")
//							if (currentStep-1 == loopRanges[currentLoopRange-1].1){
//								print("last tile is a loop")
//								commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//								loopLabels[currentIndexCorrected-currentLoopRange].frame.origin.y += 10 //might crash
//							}
//							else{
//								print("the previous tiles are elsewhere")
//								commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//							}
//						}
//						else{ //no longer possible case
//							print("all of the loops are ahead of this tile")
//							commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//						}


//				print("_7 current loop range : "+String(currentLoopRange))
//				if (loopRanges.count>0){//there are loops
//					if (currentLoopRange-1 < loopRanges.count && currentLoopRange-1 > 0) { //there might be a loop previously
//						print("_1")
//						if (currentStep-1 == loopRanges[currentLoopRange-1].1 ){ //last tile is a loop.
//							print("_2")
//							commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//							print("_3")
//							loopLabels[currentIndexCorrected-totalNumOfLoops].frame.origin.y += 10
//							print("_4")
//						}
//						else{ //last tile is not a loop, but there were loops previously
//							if (currentStep == loopRanges[currentLoopRange].0) //if the current tile is the beginning of a loop
//							{
//								print("_14")
//								commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//								print("_15")
//							}
//							else{ //current tile is not the beginning of a loop but might be in a loop. does not have the authority to push up previous tile
//								print("_16")
//								//commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//								print("_17")
//							}
//
//						}
//					}
//					else{ //no previous loop
//						if (loopRanges.count > currentLoopRange){ //if the current tile might be a loop
//							if (currentStep == loopRanges[currentLoopRange].0) //if the current tile is the beginning of a loop
//							{
//								print("_5")
//								commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//								print("_6")
//							}
//							else{ //current tile is not the beginning of a loop but might be in a loop. does not have the authority to push up previous tile
//								print("_12")
//								//commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//								print("_13")
//							}
//						}
//						else{ //there are no loops, so current tile cannot be one
//							print("_10")
//							commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//							print("_11")
//						}
//					}
//				}
//
//				print("________________________________________________________")
//				//+y is downwards, so this moves the previous tile back down
//				//BUG: we need to borrow the below loop-detection logic to make sure we don't move the same block multiple times
//				print("1")
//				//printStatus()
//				print("2")
//				print("loopranges.count :"+String(loopRanges.count)+", totalnumofloops :"+String(totalNumOfLoops)+", currentlooprange :"+String(currentLoopRange))
//				if (loopRanges.count != 0 && currentLoopRange<totalNumOfLoops) { //if there are loops and not finished iterating through loops. 2nd condition is required to avoid out of bounds in //loopranges
//					print("3.1")
//					if currentLoopRange > 0{ //if there even is a last loop
//						print("3.111")
//						print("last loop end index: "+String(loopRanges[currentLoopRange-1].1))
//						if (currentStep-1 == loopRanges[currentLoopRange-1].1){ //if last tile is a loop
//							print("beginning of loop. move up previous one")
//							//double check to prevent crash
//							if (currentIndexCorrected-1 >= 0) {
//								print("3.21")
//								commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//							}
//							if (loopLabels.count-2 >= 0){
//								print("3.22")
//								loopLabels[loopLabels.count-2].frame.origin.y += 10
//							}
//		//					print("beginning of loop. move up previous one")
//		//					commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//		//					print("3.2")
//		//					loopLabels[currentLoopRange-1].frame.origin.y += 10
//						}
//
//						else{ //last step is not a loop
//							if (currentStep > loopRanges[currentLoopRange].0){ //indices that are not at the beginning of the current loop should not be allowed to move last tile down
//								print("beginning of loop. move up")
//								if (currentIndexCorrected-1 >= 0) {
//									print("3.23")
//									commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//								}
//								print("3.8")
//							}
//						}
//
//					}
//					else{
//						print("there is no previous tile at all")
//					}
//				}
//	//			else if (loopRanges.count != 0 && currentStep-1 == loopRanges[loopRanges.count-1].1){ //if there are loops and we just moved out of a loop
//	//				//the previous one was a loop and this one is not a loop. will still need to bring the loop's number down
//	//				print("previous tile is loop")
//	//				commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//	//				print("3.9")
//	//				loopLabels[loopLabels.count-1].frame.origin.y += 10
//	//				print("3.10")
//	//			}
//				else{//there are no loops at all
//					print("no loops")
//					//currentIndexCorrected += 1
//					if (currentIndexCorrected-1 >= 0) {
//						print("3.24")
//						commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//					}
//					print("3.11")
//					//loopLabels[currentLoopRange].frame.origin.y += 10
//				}
//
//				/*
//				if (currentIndexCorrected-1 >= 0) {
//					commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10
//				}
//				if (loopLabels.count-1 >= 0){
//					loopLabels[loopLabels.count-1].frame.origin.y += 10
//				}*/
//
//				//commandQueueViews[currentIndexCorrected-1].frame.origin.y += 10




//			if (currentIndexCorrected < (commandQueue.count - 1)) {
//if (currentStep < (commandQueue.count - 1)) {
//				if loopRanges.count != 0 && currentLoopRange<totalNumOfLoops {
//					if (currentStep==loopRanges[currentLoopRange].0){
//						print("beginning of loop. move up")
//						commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
//						print("3.12")
//						loopLabels[currentLoopRange].frame.origin.y -= 10
//						print("3.13")
//					}
//
//				}
//				else{
//					//there are no loops at all
//					print("no loops")
//					//currentIndexCorrected += 1
//					commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
//					print("3.14")
//				}
//
//commandQueueViews[currentIndexCorrected].frame.origin.y -= 10
//			}
//			var maybewon: Bool
//			(moved, maybewon) = (cmdHandler?.handleCmd(input: commandQueue[currentStep]))!



//						if (currentIndexCorrected != commandQueueViews.count - 1){
//							if loopRanges.count != 0 && currentLoopRange<totalNumOfLoops {
//								print("3.3")
//								if (currentStep==loopRanges[currentLoopRange].0 && loopRanges.count>1){
//									print("beginning of loop. move up")
//									commandQueueViews[currentIndexCorrected].frame.origin.y += 10
//									print("3.4")
//									loopLabels[currentLoopRange].frame.origin.y += 10
//									print("3.5")
//								}
//								else if (currentStep==loopRanges[currentLoopRange].0){
//									print("beginning of loop. move up")
//									commandQueueViews[currentIndexCorrected].frame.origin.y += 10
//									print("3.6")
//								}
//
//							}
//							else if (loopRanges.count != 0 && currentStep-1 == loopRanges[loopRanges.count-1].1){
//								//the previous one was a loop and this one is not a loop. will still need to bring the loop's number down
//								print("previous tile is loop")
//								commandQueueViews[currentIndexCorrected].frame.origin.y += 10
//								print("3.15")
//								loopLabels[loopLabels.count].frame.origin.y += 10
//								print("3.16")
//							}
//							else{
//								//there are no loops at all
//								print("no loops")
//								//currentIndexCorrected += 1
//								commandQueueViews[currentIndexCorrected].frame.origin.y += 10
//								print("3.17")
//								//loopLabels[currentLoopRange].frame.origin.y += 10
//							}
//						}


//			else{
//				//DEPRACATED...too many visual artifacts
//				print("this should not happen")
//				print("starting loop")
//				let commandToPlay=loopCommands[loopCommands.count-loopIndex-1]
//				let numOfLoopsToPlay=numOfLoopsPerLoop[numOfLoopsPerLoop.count-loopIndex-1]
//				print("process loop "+String(commandToPlay) + "___" + String(numOfLoopsToPlay))
//
//				(moved, onShip) = (cmdHandler?.handleLoop(commandToLoop: commandToPlay, numOfLoops: numOfLoopsToPlay))!
//				loopIndex += 1
//				print("done")
//			}
*/*/*/
