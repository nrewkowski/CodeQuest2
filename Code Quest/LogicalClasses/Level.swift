//
//  Stage.swift
//  Code Quest
//
//  Created by OSX on 9/21/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

///Contains initialization data for a level
class Level: NSObject, NSCoding {
	
	///Level's name
    var name: String
	///Array of (to be) enums specifying level data, accessed `data[y][x]`
    var data: [[Int]]
	///The player's starting location, `(x,y)`
	var startingLoc : (Int, Int)
	///The goal's location `(x,y)`
	var goalLoc : (Int, Int)
	///The text that appears upon starting a level
	var tutorialText : String
	///Optional, the background displayed on the tutorial screen
	var background : String?
	///A bool representing whether the level has been cleared
	var cleared : Bool
	///The player's best score on this level
	var highscore : Int
	
	var starsGotten: Int
	
	var parNumMoves: Int
	
	var numOfMovesRequiredPerStar: [Int] = [0,0,0]
	
	
	static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
	static let ArchiveURL = DocumentsDirectory.appendingPathComponent("levels")
	
	
	
	struct PropertyKey {
		static let nameKey = "name"
		static let dataKey = "data"
		static let startingLocXKey = "startingLocX"
		static let startingLocYKey = "startingLocY"
		static let goalLocXKey = "goalLocX"
		static let goalLocYKey = "goalLocY"
		static let tutorialTextKey = "tutorialText"
		static let backgroundKey = "background"
		static let clearedKey = "cleared"
		static let highscoreKey = "highscore"
		static let starsGottenKey = "starsGotten"
		static let parNumMovesKey = "parNumMoves"
		static let numOfMovesRequiredFor1StarKey = "numOfMovesRequiredFor1Star"
		static let numOfMovesRequiredFor2StarKey = "numOfMovesRequiredFor2Star"
		static let numOfMovesRequiredFor3StarKey = "numOfMovesRequiredFor3Star"
	}
	
	init(name: String, data: [[Int]], startingLoc: (Int, Int), goalLoc: (Int, Int), tutorial: String, starsGotten:Int, parNumMoves:Int, numOfMovesRequiredPerStar: [Int]){
        self.name = name
        self.data = data
		self.startingLoc = startingLoc
		self.goalLoc = goalLoc
		self.tutorialText = tutorial
		self.cleared = false
		self.highscore = 0
		self.starsGotten=starsGotten
		self.parNumMoves=parNumMoves
		self.numOfMovesRequiredPerStar=numOfMovesRequiredPerStar
    }
	
	required init (coder aDecoder: NSCoder) {
		self.name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
		self.data = aDecoder.decodeObject(forKey: PropertyKey.dataKey) as! [[Int]]
		let startingLocX = aDecoder.decodeInteger(forKey: PropertyKey.startingLocXKey)

		let startingLocY = aDecoder.decodeInteger(forKey: PropertyKey.startingLocYKey) as! Int
		self.startingLoc = (startingLocX, startingLocY)
		
		let goalLocX = aDecoder.decodeInteger(forKey: PropertyKey.goalLocXKey)
		let goalLocY = aDecoder.decodeInteger(forKey: PropertyKey.goalLocYKey)
		self.goalLoc = (goalLocX, goalLocY)
		self.tutorialText = aDecoder.decodeObject(forKey: PropertyKey.tutorialTextKey) as! String
		self.background = aDecoder.decodeObject(forKey: PropertyKey.backgroundKey) as? String
		self.cleared = aDecoder.decodeBool(forKey: PropertyKey.clearedKey)
		self.highscore = aDecoder.decodeInteger(forKey: PropertyKey.highscoreKey)
		self.starsGotten=aDecoder.decodeInteger(forKey: PropertyKey.starsGottenKey)
		self.parNumMoves=aDecoder.decodeInteger(forKey: PropertyKey.parNumMovesKey)
		self.numOfMovesRequiredPerStar[0]=aDecoder.decodeInteger(forKey: PropertyKey.numOfMovesRequiredFor1StarKey)
		self.numOfMovesRequiredPerStar[1]=aDecoder.decodeInteger(forKey: PropertyKey.numOfMovesRequiredFor2StarKey)
		self.numOfMovesRequiredPerStar[2]=aDecoder.decodeInteger(forKey: PropertyKey.numOfMovesRequiredFor3StarKey)
	}
	
	/**
	Returns the dimensions of the player grid
	
	-returns: dimensions of the grid as `(x,y)`
	*/
    func getDimenions() -> (Int, Int) {
        let yd = data.count
        let xd = data[0].count
        return (xd, yd)
    }
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: PropertyKey.nameKey)
		aCoder.encode(data, forKey: PropertyKey.dataKey)
		aCoder.encode(startingLoc.0, forKey: PropertyKey.startingLocXKey)
		aCoder.encode(startingLoc.1, forKey: PropertyKey.startingLocYKey)
		aCoder.encode(goalLoc.0, forKey: PropertyKey.goalLocXKey)
		aCoder.encode(goalLoc.1, forKey: PropertyKey.goalLocYKey)
		aCoder.encode(tutorialText, forKey: PropertyKey.tutorialTextKey)
		aCoder.encode(background, forKey: PropertyKey.backgroundKey)
		aCoder.encode(cleared, forKey: PropertyKey.clearedKey)
		aCoder.encode(highscore, forKey: PropertyKey.highscoreKey)
		aCoder.encode(parNumMoves, forKey: PropertyKey.parNumMovesKey)
		aCoder.encode(starsGotten, forKey: PropertyKey.starsGottenKey)
		aCoder.encode(numOfMovesRequiredPerStar[0], forKey: PropertyKey.numOfMovesRequiredFor1StarKey)
		aCoder.encode(numOfMovesRequiredPerStar[1], forKey: PropertyKey.numOfMovesRequiredFor2StarKey)
		aCoder.encode(numOfMovesRequiredPerStar[2], forKey: PropertyKey.numOfMovesRequiredFor3StarKey)
	}
	
	
}
