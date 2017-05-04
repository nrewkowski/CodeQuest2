//
//  BreakableWallCell.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 4/7/17.
//  Copyright © 2017 Spookle. All rights reserved.
//


import UIKit
import AVFoundation


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
	
	var row:Int = -1
	var column:Int = -1
	var audioPlayer3 = AVAudioPlayer()
	
	//var imagesToUse:[UIImage] = []
	
	init(initialHealth:Int) {
		self.isWall = true
		self.isFuel = false
		self.health = initialHealth
		self.initialHealth = initialHealth
		
		//here, use switch case to find correct wall images
		super.init(image: UIImage(named:"wall"+String(initialHealth)+"health"+String(initialHealth)+".png"))
		self.accessibilityLabel = "Wall needs "+String(initialHealth)+" blasts"
	}
	
	init(initialHealth:Int, row:Int, column:Int) {
		self.isWall = true
		self.isFuel = false
		self.health = initialHealth
		self.initialHealth = initialHealth

		self.row=row
		self.column=column
		
		super.init(image: UIImage(named:"wall"+String(initialHealth)+"health"+String(initialHealth)+".png"))
		self.accessibilityLabel = "Wall needs "+String(initialHealth)+" blasts, row "+String(self.row)+", column "+String(self.column)
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
		self.image = UIImage(named:"wall"+String(initialHealth)+"health"+String(initialHealth)+".png")
		self.accessibilityLabel = "Cracked wall"
	}
	
	func loseHealth(){
		self.health = self.health - 1
		//super.init(image: UIImage(named:"break_wall.png"))
		
		do{
			print("played blast")
			try audioPlayer3 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "kaboom", ofType:"wav")!))
			
			audioPlayer3.volume = 1.0
			//audioPlayer.play
			audioPlayer3.prepareToPlay()
			audioPlayer3.play()
		}catch{
			print("sound failed")
		}
		if (health == 0) {
			makeNotWall()
			
//			do{
//				print("played blast")
//			try audioPlayer3 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "kaboom", ofType:"wav")!))
//			
//			audioPlayer3.volume = 1.0
//			//audioPlayer.play
//			audioPlayer3.prepareToPlay()
//			audioPlayer3.play()
//			}catch{
//				print("sound failed")
//			}
		}
		else{
			self.image = UIImage(named:"wall"+String(initialHealth)+"health"+String(health)+".png")
			self.accessibilityLabel = "Wall needs "+String(health)+" blasts"
		}
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
