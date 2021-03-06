//
//  floorCell.swift
//  Code Quest
//
//  Created by (You) Narukami on 9/20/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit


///Floor cells, which current can be empty or contain the player
class floorCell: gameCell {

	///Indicates whether or not the cell contains the player
	var isPlayer: Bool = false
	///Indicates whether or not the cell contains the goal
	var isGoal: Bool = false
	///Indicates whether or not the cell is a breakable wall
	var isWall: Bool
	/// Indicated whether or not the cell is fuel
	var isFuel: Bool
	var wasGoal: Bool = false
	var row:Int = -1
	var column:Int = -1
	
	//kept this to avoid breaking cq1 too much
	init(isWall: Bool, isFuel: Bool) {
		self.isWall = isWall
		self.isFuel = isFuel
		
		if isPlayer {
			super.init(image: UIImage(named:"player.png"))
			self.accessibilityLabel = "Player"
		} else if(isWall) {
			super.init(image: UIImage(named:"break_wall.png"))
			self.accessibilityLabel = "Cracked wall"
		} else if (isFuel) {
			super.init(image: UIImage(named:"fuel_grid.png"))
			self.accessibilityLabel = "Fuel"
			self.contentMode = .scaleAspectFit
		} else {
			super.init(image: UIImage(named:"grid.png"))
			self.accessibilityLabel = "Empty"
		}
		//self.accessibilityTraits = UIAccessibilityTraitNone
    }
	
	init(isWall: Bool, isFuel: Bool, row:Int, column:Int) {
		self.isWall = isWall
		self.isFuel = isFuel
		self.row=row
		self.column=column
		if isPlayer {
			super.init(image: UIImage(named:"player.png"))
			self.accessibilityLabel = "Player, row "+String(self.row)+", column "+String(self.column)
		} else if(isWall) {
			super.init(image: UIImage(named:"break_wall.png"))
			self.accessibilityLabel = "Cracked wall, row "+String(self.row)+", column "+String(self.column)
		} else if (isFuel) {
			super.init(image: UIImage(named:"fuel_grid.png"))
			self.accessibilityLabel = "Alien, row "+String(self.row)+", column "+String(self.column)
			self.contentMode = .scaleAspectFit
		} else {
			super.init(image: UIImage(named:"grid.png"))
			self.accessibilityLabel = "Empty, row "+String(self.row)+", column "+String(self.column)
		}
		//self.accessibilityTraits = UIAccessibilityTraitNone
	}
	
	///Changes image and VoiceOver label to player
	func makePlayer() {
		isPlayer = true
		isFuel = false
		//self.image = UIImage(named:"player.png")
		self.accessibilityLabel = "Player, row "+String(self.row)+", column "+String(self.column)
		//self.accessibilityTraits = UIAccessibilityTraitNone
	}
	
	///Changes image and VoiceOver label to floor
	func makeNotPlayer() {
		isPlayer = false
		if wasGoal {
			self.makeGoal()
		} else {
			self.image = UIImage(named:"grid.png")
			self.accessibilityLabel = "Empty, row "+String(self.row)+", column "+String(self.column)
			//self.accessibilityTraits = UIAccessibilityTraitNone
		}
	}
	
	///Changes image and VoiceOver label to goal
	func makeGoal() {
		isGoal = true
		wasGoal = true
		self.image = UIImage(named:"ship_grid.png")
		self.accessibilityLabel = "Ship, row "+String(self.row)+", column "+String(self.column)
		//self.accessibilityTraits = UIAccessibilityTraitNone
	}
	
	func makeNotWall() {
		self.isWall = false
		self.image = UIImage(named:"grid.png")
		self.accessibilityLabel = "Empty, row "+String(self.row)+", column "+String(self.column)
		//self.accessibilityTraits = UIAccessibilityTraitNone
	}
	
	func makeWall() {
		self.isWall = true
		//self.image = UIImage(named:"break_wall.png")
		self.accessibilityLabel = "Cracked wall, row "+String(self.row)+", column "+String(self.column)
		//self.accessibilityTraits = UIAccessibilityTraitNone
	}
	
	func makeFuel() {
		self.isFuel = true
		self.image = UIImage(named:"fuel_grid.png")
		self.accessibilityLabel = "Alien, row "+String(self.row)+", column "+String(self.column)
		//self.accessibilityTraits = UIAccessibilityTraitNone
		self.contentMode = .scaleAspectFit
	}
	
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
