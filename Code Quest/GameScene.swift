//
//  GameScene.swift
//  Code Quest
//
//  Created by OSX on 11/3/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import Foundation
import SpriteKit

///The SpriteKit overlay that handles player movement
class GameScene : SKScene {
	///The player sprite
	let player = SKSpriteNode(texture: SKTexture(imageNamed: "pt"))
	///The player position in level coordinates
	var playerPosition : (Int, Int) = (0,0)
	var boomFrames = [SKTexture]()
	var pewFrames = [SKTexture]()
	var boomSound = SKAudioNode(fileNamed: "kaboom.wav")
	var pewSound = SKAudioNode(fileNamed: "lazar.wav")
	
	override func didMove(to view: SKView) {
		boomSound.autoplayLooped = false
		pewSound.autoplayLooped = false
		backgroundColor = SKColor.clear
		player.position = getPlayerCoordinates()
		addChild(player)
		addChild(boomSound)
		addChild(pewSound)
		self.listener = player
		for i in 1...17 {
			boomFrames.append(SKTexture(imageNamed: "boom (\(i)).png"))
			boomFrames[i-1].preload(completionHandler: {})
			print("boom (\(i)).png")
		}
		for i in -2...0 {
			pewFrames.append(SKTexture(imageNamed: "blast\(i).png"))
			pewFrames[i+2].preload(completionHandler: {})
		}
		let blank = SKTexture(imageNamed: "blast5.png")
		blank.preload(completionHandler: {})
		pewFrames.append(blank)
	}
	
	///Returns the player's screen coordinates based on their level coordinates
	func getPlayerCoordinates() -> CGPoint {
		return mapToScreenCoordinates(newPos: playerPosition)
	}
	
	///Maps level coordinates to screen coordinates
	func mapToScreenCoordinates(newPos : (Int, Int)) -> CGPoint {
		return CGPoint(x: ViewController.moveInc * newPos.0 + 45, y: Int(self.size.height) - (45 + 64 + ViewController.moveInc * newPos.1))
	}
	
	///Updates the player's location in level coordinates
	func movePlayer(newPos : (Int, Int)) {
		if newPos.0 < playerPosition.0 {
			player.xScale = -1
		} else if newPos.0 > playerPosition.0 {
			player.xScale = 1
		}
		playerPosition = newPos
		let playerMove = SKAction.move(to: getPlayerCoordinates(), duration: 0.15)
		print(newPos)
		print(getPlayerCoordinates())
		player.run(playerMove)
		
	}
	
	///Updates the player's level coordinates without animating
	func setPlayerPos(newPos: (Int, Int)) {
		playerPosition = newPos
		player.position = getPlayerCoordinates()
		player.xScale = 1
	}
	
	///Moves the player towards the specified level coordinates, playing the bonk animation instead. 
	func tryToMoveTo(newPos: (Int, Int)) {
		let beSad = SKAction.setTexture(SKTexture(imageNamed: "ps"))
		let beHappy = SKAction.setTexture(SKTexture(imageNamed: "pt"))
		var scalo = SKAction.wait(forDuration: 0)
		if newPos.0 < playerPosition.0 {
			player.xScale = -1
			scalo = SKAction.scaleX(to: 1, duration: 0)
		} else if newPos.0 > playerPosition.0 {
			player.xScale = 1
			scalo = SKAction.scaleX(to: -1, duration: 0)
		}
		let oldPos = getPlayerCoordinates()
		let theNewPos = mapToScreenCoordinates(newPos: newPos)
		let moveVector =  CGVector(dx: theNewPos.x - oldPos.x, dy: theNewPos.y - oldPos.y)
		let moveVector1 = CGVector(dx: moveVector.dx * 0.3, dy: moveVector.dy*0.3)
		let moveVector2 = CGVector(dx: moveVector.dx * -0.3, dy: moveVector.dy*(-0.3))
		let move1 = SKAction.move(by: moveVector1, duration: 0.1)
		let move2 = SKAction.move(by: moveVector2, duration: 0.1)
		let waito = SKAction.wait(forDuration: 0.25)
		let moveSequence = SKAction.sequence([move1, beSad, scalo, move2, waito, beHappy])
		player.run(moveSequence)
		
		
	}
	
	func kaboom (pos: (Int, Int)) {
		let kaboomo = SKSpriteNode(imageNamed: "break_wall.png")
		kaboomo.xScale = CGFloat(ViewController.moveInc) / kaboomo.size.width
		kaboomo.yScale = CGFloat(ViewController.moveInc) / kaboomo.size.height
		
		addChild(kaboomo)
		kaboomo.position = mapToScreenCoordinates(newPos: pos)
		boomSound.position = kaboomo.position
		kaboomo.run(SKAction.sequence([
			SKAction.wait(forDuration: 0.15),
			SKAction.animate(with: boomFrames, timePerFrame: 0.0625),
			SKAction.wait(forDuration: 1),
			SKAction.removeFromParent()
		]))
		boomSound.run(SKAction.sequence([
				SKAction.wait(forDuration: 0.15),
				SKAction.play()
		]))
		
	}
	
	func pewpew (pos: (Int, Int)) {
		let pew = SKSpriteNode(imageNamed: "blast-2.png")
		addChild(pew)
		pew.position = mapToScreenCoordinates(newPos: pos)
		pewSound.position = pew.position
		pewSound.run(SKAction.play())
		pew.run(SKAction.sequence([
			SKAction.animate(with:pewFrames, timePerFrame:0.09),
			SKAction.wait(forDuration: 1),
			SKAction.removeFromParent()
		]))
		
		
	}
}
