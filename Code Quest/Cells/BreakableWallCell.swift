//
//  BreakableWallCell.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 4/7/17.
//  Copyright © 2017 Spookle. All rights reserved.
//


import UIKit


///Floor cells, which current can be empty or contain the player
class BreakableWallCell: gameCell {
	
	///Indicates whether or not the cell contains the player
	var isPlayer: Bool = false
	///Indicates whether or not the cell contains the goal
	var isGoal: Bool = false
	///Indicates whether or not the cell is a breakable wall
	var isWall: Bool
	/// Indicated whether or not the cell is fuel
	var isFuel: Bool
	var wasGoal: Bool = false
	
	var health:Int = 0
	var initialHealth = 0 //will be used to tell material for now. can explicitly name material later
	
	init(initialHealth:Int) {
		self.isWall = true
		self.isFuel = false
		self.health = initialHealth
		self.initialHealth = initialHealth
		
		//here, use switch case to find correct wall images
		super.init(image: UIImage(named:"break_wall.png"))
		self.accessibilityLabel = "Wall with "+String(initialHealth)+" health"
	}
	
	///Changes image and VoiceOver label to player
	func makePlayer() {
		isPlayer = true
		isFuel = false
		self.image = UIImage(named:"player.png")
		self.accessibilityLabel = "Player"
	}
	
	///Changes image and VoiceOver label to floor
	func makeNotPlayer() {
		isPlayer = false
		self.image = UIImage(named:"grid.png")
		self.accessibilityLabel = "Empty"
		
	}
	
	
	func makeNotWall() {
		self.isWall = false
		self.image = UIImage(named:"grid.png")
		self.accessibilityLabel = "Empty"
	}
	
	func makeWall() {
		self.isWall = true
		self.health = initialHealth
		self.image = UIImage(named:"break_wall.png")
		self.accessibilityLabel = "Cracked wall"
	}
	
	func loseHealth(){
		self.health = self.health - 1
		//super.init(image: UIImage(named:"break_wall.png"))
		self.image = UIImage(named:"ship_grid.png")
		self.accessibilityLabel = "Wall with "+String(health)+" health"
		
		if (health == 0) {
			makeNotWall()
		}
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
