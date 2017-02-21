//
//  CommandViewController.swift
//  Code Quest
//
//  Created by OSX on 9/28/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit
let num_command_buttons = 8

// The first num_queue_buttons buttons represent queueable commands that should come before the divider
let num_queue_buttons = 5

///View that contains command butotns
class CommandView: UIView {

	///Array of command buttons
	var commandButtons = [Input]()
	///The game controller that is this view's parent
	var gameControllerView : ViewController?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		for i in 0..<num_command_buttons {
			// Separate the first num_queue_buttons from the others with some empty space
			let xcoord = (i < num_queue_buttons) ? 100*i : 100*i + 50
			let command = Input(type: ButtonType(rawValue : i)!, frame: CGRect(x: min(xcoord, ViewController.scaleDims(input: xcoord, x: true)), y: 0, width: min(96, ViewController.scaleDims(input: 96, x: true)), height: min(96, ViewController.scaleDims(input: 96, x: false))));
			//command.backgroundColor = UIColor.cyan
			
			//command.addTarget(self, action: #selector(CommandView.commandTapped(_:)), for: .Touchdown)
			command.addTarget(self, action: #selector(CommandView.commandTapped(commandButton:)), for: .touchDown)
			commandButtons += [command]
			self.addSubview(command)
		}
	}
	
	/*override func intrinsicContentSize() -> CGSize {
		return CGSize(width: 240, height:44)
	}*/
	
	func commandTapped(commandButton: Input) {
		let cmdIndex = commandButton.type
		print("Command pressed \(cmdIndex)")
		gameControllerView?.getButtonInput(type: commandButton.type)
		//print(self.parent?.title)
		
	}
	
}
