//
//  CommandHandler.swift
//  Code Quest
//
//  Created by Anthony Lawrence Vallario on 10/3/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class CommandHandler {
	
	/// Cell-based representation of the level
	var level: [[gameCell]]
	/// Location of the Player in (x, y)
	var playerLoc: (Int, Int)
	/// Location of the goal in (x, y)
	var goalLoc: (Int, Int)
	/// Number of commands run
	var commandCount: Int = 0
	var myGameScene : GameScene
	var onGoal : Bool = false
	var audioPlayer2 = AVAudioPlayer()

	init(level : inout [[gameCell]], playerLoc : inout (Int, Int), goalLoc : inout (Int, Int), myGameScene: GameScene) {
		//TODO: Fix gamescene bodge
		self.level = level
		self.playerLoc = playerLoc
		self.goalLoc = goalLoc
		self.myGameScene = myGameScene
	}
	
	/**
	Handles a single command. Returns true if the player wins.
	
	- parameter input: integer indicating selected command
	- parameter playerLoc: tuple indicating the coordinates of the player
	
	*/
	func handleCmd(input: Int) -> (Bool, Bool) {
		// Switch command input type, call appropriate functions
		// Current encoding:	0 - Left
		//						1 - Up
		//						2 - Down
		//						3 - Right
		
		if (input == 0 || input == 1 || input == 2 || input == 3) {
			return (self.moveCmd(input: input), onGoal)
		} else if(input == 4) {
			blastCommand()
			return (false, onGoal)
		} else {
			print("Unrecognized command index: \(input)")
			return (false, onGoal)
		}
	}
	
	func handleLoop(commandToLoop: Int, numOfLoops: Int) -> (Bool, Bool) {
		var returnValue1=false
		if (commandToLoop == 0 || commandToLoop == 1 || commandToLoop == 2 || commandToLoop == 3) {
			DispatchQueue.main.sync{
				for i in 0...numOfLoops-1 {
					returnValue1 = self.moveCmd(input: commandToLoop)
				}
			}
			
			
			return (returnValue1, onGoal)
		}
		else if(commandToLoop == 4) {
			for i in 0...numOfLoops-1 {
				blastCommand()
			}
			
			return (false, onGoal)
		} else {
			print("Unrecognized command index: \(commandToLoop)")
			return (false, onGoal)
		}
	}
	
	// Specialized command handling functions
	
	/**
	Given a command, returns the coordinate that command would move the player to.
	
	- parameter input: integer indicating selected command
	
	*/
	func newCoordsFromCommand(input: Int) -> (Int, Int) {
		// Get player location offsets from move direction
		var dx = 0
		var dy = 0
		
		switch input {
		case 0:
			dx = -1
		case 1:
			dy = -1
		case 2:
			dy = 1
		case 3:
			dx = 1
		default:
			print("Out of range input to moveCmd: \(input)")
		}
		return (playerLoc.0 + dx, playerLoc.1 + dy)
	}
	
	/**
	Given a command, tries to move the player. Returns a tuple of bools indicating if the player succesfully moved, and if they won on that turn
	
	- parameter input: integer indicating selected command
	
	*/
	func moveCmd(input: Int) -> Bool {
		var sounds = [leftSound, rightSound, upSound, downSound]
		let newCoords = newCoordsFromCommand(input: input)
		let moved = setPlayerLoc(newCoords: newCoords)
		if(moved) {
			playSound(sound: sounds[input])
		} else {
			playSound(sound: bumpSound)
		}
		onGoal = (playerLoc == goalLoc)
		return moved
	}
	
	/**
	Checks surrounding spaces for breakable walls, then calls blast function on relevant cells
	*/
	func blastCommand() {
		var alreadyBlasted=false
		print(String(alreadyBlasted)+"*************************************************************************************************************************")
		print(playerLoc)
		print(level)
		print(level.count)
		print(level[0].count)
		myGameScene.pewpew(pos: (playerLoc.0, playerLoc.1))
		
		//this ignores unbreakable walls simply because unbreakable walls are of wallCell class and unbreakable walls are of floorcell class. this needs to be changed; it makes no sense!
		if(playerLoc.0 > 0) {
			print(1)
			if let loc = level[playerLoc.1][playerLoc.0 - 1] as? BreakableWallCell {
				if(loc.isWall) { //will always be wall
					myGameScene.kaboom(pos: (playerLoc.0 - 1, playerLoc.1),shouldPlayNoise: !alreadyBlasted)
					alreadyBlasted=true
					loc.loseHealth()
				}
			}
		}
		if(playerLoc.0 < level[0].count - 1) {
			print(2)
			if let loc = level[playerLoc.1][playerLoc.0 + 1] as? BreakableWallCell {
				if(loc.isWall) {
					myGameScene.kaboom(pos: (playerLoc.0 + 1, playerLoc.1),shouldPlayNoise: !alreadyBlasted)
					alreadyBlasted=true
					loc.loseHealth()

				}
			}
		}
		if(playerLoc.1 > 0) {
			print(3)
			if let loc = level[playerLoc.1 - 1][playerLoc.0] as? BreakableWallCell {
				if(loc.isWall) {
					myGameScene.kaboom(pos: (playerLoc.0, playerLoc.1 - 1),shouldPlayNoise: !alreadyBlasted)
					alreadyBlasted=true
					loc.loseHealth()

				}
			}
		}
		if(playerLoc.1 < level.count - 1) {
			print(4)
			if let loc = level[playerLoc.1 + 1][playerLoc.0] as? BreakableWallCell {
				if(loc.isWall) {
					myGameScene.kaboom(pos: (playerLoc.0, playerLoc.1 + 1),shouldPlayNoise: !alreadyBlasted)
					alreadyBlasted=true
					loc.loseHealth()

				}
			}
		}
	}
	
	//func moveLoop(input:Int)
	
	// Utility functions
	
	/**
	Updates the level tile grid to reflect a new player position, if the player
	is allowed to be there. Returns a tuple whose first value is true if the player successfully moved,
	and whose second value is true if the player moved to the goal.
	
	-parameter playerLoc: current player loc
	-parameter newCoords: coordinates to try to move the player to
	
	*/
	func setPlayerLoc(newCoords: (Int, Int)) -> Bool {
		print("#^#^#^$&$*$*#*#*#*#**#$*&%&%&%&%&%&%&%&%&*%*%(((#(#(##^#^#^$&$*$*#*#*#*#**#$*&%&%&%&%&%&%&%&%&*%*%(((#(#(##^#^#^$&$*$*#*#*#*#**#$*&%&%&%&%&%&%&%&%&*%*%(((#(#(#")
		if (newCoords.0 >= 0) && (newCoords.0 < level[0].count) && (newCoords.1 >= 0) && (newCoords.1 < level.count) {  //Check boundaries
			if let oldLoc = level[playerLoc.1][playerLoc.0] as? floorCell, let newLoc = level[newCoords.1][newCoords.0] as? floorCell {		//Check if space is floor
				
				// Check if the wall is an unblasted blastable tile
				if (newLoc.isWall) {
					return false
				}
				
				if newLoc.isFuel {
					print("was fuel")
					//playSound(sound: URL(fileURLWithPath: Bundle.main.path(forResource: "AlienSound", ofType:"wav")!))
					
					do {
						try audioPlayer2 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "AlienSound", ofType:"wav")!))
						
						audioPlayer2.volume = 1.0
						//audioPlayer.play
						audioPlayer2.prepareToPlay()
						audioPlayer2.play()
						
					} catch{
						print ("Failed to play sound:")
					}
				}
				//print("make not player")
				if (playerLoc.0 != 0 || playerLoc.1 != 0){
					oldLoc.makeNotPlayer()
				}
				
				playerLoc = newCoords
				let isGoal = newLoc.isGoal
				
				if (!isGoal) {
					//i guess that they get rid of the alien just by using makeplayer and setting isfuel to false...that's about it. when the player leaves the tile that used to be the alien, makenotplayer just sets it to empty. this system of replacing the tiles entirely is really bad design. we should fix this at some point
					newLoc.makePlayer()
				}
				return true
			}
			
					//need to handle this case because floorcell != breakablewallcell, so if you are standing on what was once a brekaablewall, the previous case will be false
				else if let oldLoc = level[playerLoc.1][playerLoc.0] as? BreakableWallCell, let newLoc = level[newCoords.1][newCoords.0] as? floorCell {		//Check if space is floor
					
					// Check if the wall is an unblasted blastable tile
					if (newLoc.isWall) {
						return false
					}
					
					if newLoc.isFuel {
						print("was fuel")
						//playSound(sound: URL(fileURLWithPath: Bundle.main.path(forResource: "AlienSound", ofType:"wav")!))
						
						do {
							try audioPlayer2 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "AlienSound", ofType:"wav")!))
							
							audioPlayer2.volume = 1.0
							//audioPlayer.play
							audioPlayer2.prepareToPlay()
							audioPlayer2.play()
							
						} catch{
							print ("Failed to play sound:")
						}
					}
					//print("make not player")
					if (playerLoc.0 != 0 || playerLoc.1 != 0){
						oldLoc.makeNotPlayer()
					}
					playerLoc = newCoords
					let isGoal = newLoc.isGoal
					
					if (!isGoal) {
						//i guess that they get rid of the alien just by using makeplayer and setting isfuel to false...that's about it. when the player leaves the tile that used to be the alien, makenotplayer just sets it to empty. this system of replacing the tiles entirely is really bad design. we should fix this at some point
						newLoc.makePlayer()
					}
					return true
				}
			
			else if let oldLoc = level[playerLoc.1][playerLoc.0] as? floorCell, let newLoc = level[newCoords.1][newCoords.0] as? BreakableWallCell {
				print("breakable")
				
				if (newLoc.isWall) {
					return false
				}
				if (playerLoc.0 != 0 || playerLoc.1 != 0){
					oldLoc.makeNotPlayer()
				}
				playerLoc = newCoords
				let isGoal = newLoc.isGoal
				
				if (!isGoal) {
					//i guess that they get rid of the alien just by using makeplayer and setting isfuel to false...that's about it. when the player leaves the tile that used to be the alien, makenotplayer just sets it to empty. this system of replacing the tiles entirely is really bad design. we should fix this at some point
					newLoc.makePlayer()
				}
				return true
			}
			
			else {
				print("not a floor")
				return false
			}
		}
		else {
			return false
		}
	}
	
	///For reset of level (e.g.pressing play) - restores goal image/label on goal cell
	func resetGoal(coords: (Int, Int)) -> Bool {
		if let loc = level[goalLoc.1][goalLoc.0] as? floorCell {
			loc.makeGoal()
			return true
		} else {
			return false
		}
	}
	
}
