//
//  ViewController.swift
//  Code Quest
//
//  Created by OSX on 9/19/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit
import Darwin

let imageNames = ["left", "up", "down", "right", "blast_button"]
let commandSounds = [leftSound, rightSound, upSound, downSound, blastSound]

/// Primary game controller. Contains most game state information
class ViewController: UIViewController, UICollectionViewDelegate {
	
	/// Child view that contains command butotns
    @IBOutlet var ButtonView: CommandView!
	
    /// Level data for this stage
    var level : Level? = nil
	/// Player's current location
	var playerLoc : (Int, Int) = (0,0)
	/// Goal location
	var goalLoc : (Int, Int) = (0,0)
	/// Array of gameCells representing the player's current location
	var tileArray : [[gameCell]] = []
	/// Queue of current commands
	var commandQueue : [Int] = []
    /// List of queued command views corresponding to elements of commmandQueue
    var commandQueueViews : [UIView] = []
	/// Current location in commandQueue
	var currentStep : Int = 0
	/// Timer that controls player movement
    var tickTimer = Timer()
	/// Command handler object
	var cmdHandler: CommandHandler? = nil
    /// Boolean to determine whether to accept commands
    var takeInput: Bool = true
	/// The SpriteKit layer
	var scene : GameScene? = nil
	/// The parent level table view controller
	var parentLevelTableViewController : LevelTableViewController? = nil
//	var won : Bool = false
	/// List of breakable blocks that must be reset along with the level
	var breakBlocks : [floorCell] = []
	/// List of fuel cells in the level
	var fuelCells : [floorCell] = []
	/// Number of pixels character should move/size of cells
	static let moveInc = 90
	/// Original width used
	static let origW = CGFloat(1024)
	/// Original height used
	static let origH = CGFloat(768)
	/// Boolean tracks whether the player is currently on the goal
	var onShip : Bool = false
	var aboutToWin : Bool = false
	
	let music: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "song", ofType:"aif")!);
	var musicPlayer = AVAudioPlayer()
	let drum = URL(fileURLWithPath: Bundle.main.path(forResource: "drum", ofType:"aif")!);
	var drumPlayer = AVAudioPlayer()
	

    
	/// Controls game logic
    override func viewDidLoad() {
		
        self.view.backgroundColor = UIColor(red: 27.0/256.0, green: 40.0/256.0, blue: 54.0/256.0, alpha: 1.0)
        
        super.viewDidLoad()
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
		
		
		let touchOnResetRecognizer = UITapGestureRecognizer(target: self, action: #selector (self.tapReset (_:)))
		self.view.addGestureRecognizer(touchOnResetRecognizer)
		
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
					cell.frame = CGRect(x: ViewController.scaleDims(input: ViewController.moveInc*x, x: true), y: ViewController.scaleDims(input: 64+ViewController.moveInc*y, x: false), width: ViewController.scaleDims(input: ViewController.moveInc, x: true), height: ViewController.scaleDims(input: ViewController.moveInc, x: false))
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
		
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func tapReset(_ sender: UITapGestureRecognizer) {
		if (takeInput) {
			resetLevelState()
		}
	}
	
	func resetLevelState() {
		scene?.setPlayerPos(newPos: level!.startingLoc)
		cmdHandler?.setPlayerLoc(newCoords: level!.startingLoc)
		cmdHandler?.resetGoal(coords: level!.goalLoc)
		cmdHandler?.onGoal = false
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
	func getButtonInput(type:ButtonType) {
        if (takeInput) {
            if (type.rawValue < 5 && commandQueue.count < 28) { // If command is to be added to queue and queue is not full
                let tempCell = UIImageView(image: UIImage(named:imageNames[type.rawValue] + ".png"))
				tempCell.frame = CGRect(x: ViewController.scaleDims(input: (70*commandQueue.count) % 980, x: true), y: ViewController.scaleDims(input: 526 + 70*(commandQueue.count/14), x: false), width: ViewController.scaleDims(input:64, x: true), height: ViewController.scaleDims(input: 64, x: false))
                tempCell.isAccessibilityElement = true
                tempCell.accessibilityTraits = UIAccessibilityTraitImage
                tempCell.accessibilityLabel = imageNames[type.rawValue]
				
				if (type.rawValue == 4) {
					tempCell.accessibilityLabel = "blast"
				}
				
                self.view.addSubview(tempCell)
                commandQueue.append(type.rawValue)
                commandQueueViews.append(tempCell)
                playSound(sound: commandSounds[type.rawValue])
			} else if(type.rawValue < 5 && commandQueue.count >= 28) {
				
				playSound(sound: failSound);
				let delayTime = DispatchTime.now() + .milliseconds(300)
				DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
					UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, "Command queue full");
				})
				
				
				
            } else { // Command is to be executed immediately
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
						selector:#selector(ViewController.runQueueSounds),
						userInfo:nil, repeats: true)
				}
            }
        }
	}
	
	/// Action for Play Button
    @IBAction func PlayButton(_ sender: UIButton) {
        if (takeInput) {
            // Don't take input while commands are running
            takeInput = false
			
			resetLevelState()
            
            currentStep = 0
//			won = false
            tickTimer = Timer.scheduledTimer(timeInterval: 0.4054, target:self, selector:#selector(ViewController.runCommands), userInfo:nil, repeats: true)
        }
    }
	
	/// Executes one step of the game loop
	func runCommands() {
		musicPlayer.volume = 0.1 * musicVolume
		
		var moved = false
		if (currentStep != 0 && !aboutToWin) {
			commandQueueViews[currentStep-1].frame.origin.y += 10
		}

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
				scene?.tryToMoveTo(newPos: (cmdHandler?.newCoordsFromCommand(input: commandQueue[currentStep]))!)
			}
			
		}
		currentStep += 1
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
		
		if aboutToWin {
			musicPlayer.volume = 1.0 * musicVolume
			playSound(sound: cheerSound)
			
			if !level!.cleared {
				level!.cleared = true
				level!.highscore = commandQueue.count
			} else if commandQueue.count < level!.highscore {
				level!.highscore = commandQueue.count
			}
			let alert = UIAlertController(title: "You win!", message: "You took \(commandQueue.count) steps. Your best score is \(level!.highscore).", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Yay!", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.musicPlayer.volume = 1.0 * musicVolume}))
			self.present(alert, animated: true, completion: nil)

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
	
	func win() {
		
	}
	
	func checkWin() -> Bool {
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
	func runQueueSounds() {
		if (currentStep < commandQueue.count) {
			playSound(sound: commandSounds[commandQueue[currentStep]])
			currentStep += 1
		} else {
			tickTimer.invalidate()
			takeInput = true
		}
	}
	
	///Scales pixel values to be relative to the resolution of the device
	static func scaleDims(input : Int, x : Bool) -> Int {
		let height = (UIScreen.main.bounds.height)
		let width = (UIScreen.main.bounds.width)
		let finput : CGFloat = CGFloat(input)
		return (x) ? Int(finput / ViewController.origW * width) : Int(finput / ViewController.origH * height)
	}
}

