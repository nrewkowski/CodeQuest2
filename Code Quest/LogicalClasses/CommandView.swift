//
//  CommandViewController.swift
//  Code Quest
//
//  Created by OSX on 9/28/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit
let num_command_buttons = 10

// The first num_queue_buttons buttons represent queueable commands that should come before the divider
let num_queue_buttons = 6

///View that contains command butotns
class CommandView: UIView {

	///Array of command buttons
	var commandButtons = [Input]()
	///The game controller that is this view's parent
	var gameControllerView : LevelViewController?
	
	var pickerView:UIPickerView? = nil
	
	var planetNumber = 0
	
	var blastButton : Input? = nil
	
	var loopButton : Input? = nil
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		for i in 0..<num_command_buttons {
			// Separate the first num_queue_buttons from the others with some empty space
			let xcoord = (i < num_queue_buttons) ? 84*i : 84*i + 50
			let command = Input(type: ButtonType(rawValue : i)!, frame: CGRect(x: min(xcoord, LevelViewController.scaleDims(input: xcoord, x: true)), y: 0, width: min(80, LevelViewController.scaleDims(input: 80, x: true)), height: min(80, LevelViewController.scaleDims(input: 80, x: false))), isEnabled: true);
			//command.backgroundColor = UIColor.cyan
//			if (i==5 && planetNumber < 4){
//				command.isEnabled=false
//			}
//			if (i==4 && planetNumber < 2){
//				command.isEnabled=false
//			}
			if (i==5){
				loopButton = command
			}
			if (i==4){
				blastButton = command
			}
			
			//command.addTarget(self, action: #selector(CommandView.commandTapped(_:)), for: .Touchdown)
			command.addTarget(self, action: #selector(CommandView.commandTapped(commandButton:)), for: .touchDown)
			commandButtons += [command]
			self.addSubview(command)
			if i==5 {
				
				pickerView=UIPickerView(frame: CGRect(x: min(xcoord, LevelViewController.scaleDims(input: xcoord, x: true)), y: 0, width: min(80, LevelViewController.scaleDims(input: 80, x: true)), height: min(80, LevelViewController.scaleDims(input: 80, x: false))))
				//pickerView.dataSource=self
				//pickerView.delegate=self
//				if (planetNumber<5){
//					pickerView?.isHidden=true
//				}
				self.addSubview(pickerView!)
			}
			
			
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
//let xcoord = (i < num_queue_buttons) ? 100*i : 100*i + 50
//let command = Input(type: ButtonType(rawValue : i)!, frame: CGRect(x: min(xcoord, LevelViewController.scaleDims(input: xcoord, x: true)), y: 0, width: min(96, LevelViewController.scaleDims(input: 96, x: true)), height: min(96, LevelViewController.scaleDims(input: 96, x: false))));
