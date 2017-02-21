//
//  SoundPlayer.swift
//  Code Quest
//
//  Created by Anthony Lawrence Vallario on 10/3/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import Foundation
import AVFoundation

var musicVolume : Float = 1.0

/// Sound that plays when moving left
let leftSound = URL(fileURLWithPath: Bundle.main.path(forResource: "left", ofType:"wav")!);
/// Sound that plays when moving right
let rightSound = URL(fileURLWithPath: Bundle.main.path(forResource: "right", ofType:"wav")!);
/// Sound that plays when moving up
let upSound = URL(fileURLWithPath: Bundle.main.path(forResource: "up", ofType:"wav")!);
/// Sound that plays when moving down
let downSound = URL(fileURLWithPath: Bundle.main.path(forResource: "down", ofType:"wav")!);
/// Sound that plays when bumping into a wall
let bumpSound = URL(fileURLWithPath: Bundle.main.path(forResource: "bump", ofType:"wav")!);
/// Sound that plays when command queue is full
let failSound = URL(fileURLWithPath: Bundle.main.path(forResource: "bumpo", ofType:"wav")!);
/// Sound that plays when the level is cleared
let cheerSound = URL(fileURLWithPath: Bundle.main.path(forResource: "cheer", ofType:"wav")!);
/// Audio player for sound effects
let blastSound = URL(fileURLWithPath: Bundle.main.path(forResource: "lazar", ofType:"wav")!);
/// Audio player for sound effects
var audioPlayer = AVAudioPlayer()

func playSound(sound: URL) {
	do {
		try audioPlayer = AVAudioPlayer(contentsOf: sound)
		audioPlayer.volume = 0.4
		audioPlayer.prepareToPlay()
		audioPlayer.play()

	} catch{
		print ("Failed to play sound: \(sound)")
	}
}
