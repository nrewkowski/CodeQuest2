//
//  DevCommandView.swift
//  Code Quest
//
//  Created by Nicholas Rewkowski on 3/28/17.
//  Copyright © 2017 Spookle. All rights reserved.
//

import UIKit

///View that contains command butotns
class DevCommandView: UIView {
	
	///Array of command buttons
	var commandButtons = [Input]()
	///The game controller that is this view's parent
	var gameControllerView : PlanetLevelViewController?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		for i in 0..<num_command_buttons {
			// Separate the first num_queue_buttons from the others with some empty space
			let xcoord = (i < num_queue_buttons) ? 100*i : 100*i + 50
			let command = Input(type: ButtonType(rawValue : i)!, frame: CGRect(x: min(xcoord, LevelViewController.scaleDims(input: xcoord, x: true)), y: 0, width: min(96, LevelViewController.scaleDims(input: 96, x: true)), height: min(96, LevelViewController.scaleDims(input: 96, x: false))));
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
