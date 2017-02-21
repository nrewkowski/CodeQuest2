//
//  Input.swift
//  Code Quest
//
//  Created by OSX on 9/28/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

///Buttons that render in the instruction pane
enum ButtonType:Int {
	case LEFT = 0
	case RIGHT = 3
	case UP = 1
	case DOWN = 2
	case BLAST = 4
	case ERASE1 = 5
	case ERASEALL = 6
	case QUEUESOUND = 7
}

class Input: UIButton {
	
	///(To be) enum describing what type of command this button corresponds to 
	var type: ButtonType
	
	
	init(type: ButtonType, frame: CGRect) {
		self.type = type
		super.init(frame: frame)
		switch type {
		case ButtonType.LEFT:
			self.setImage(UIImage(named:"left.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Left"
		case ButtonType.RIGHT:
			self.setImage(UIImage(named:"right.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Right"
		case ButtonType.UP:
			self.setImage(UIImage(named:"up.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Up"
		case ButtonType.DOWN:
			self.setImage(UIImage(named:"down.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Down"
		case ButtonType.ERASE1:
			self.setImage(UIImage(named:"erase1.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Erase last command"
		case ButtonType.ERASEALL:
			self.setImage(UIImage(named:"eraseall.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Erase all commands"
		case ButtonType.QUEUESOUND:
			self.setImage(UIImage(named:"queuesound.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Hear the commands you have input"
		case ButtonType.BLAST:
			self.setImage(UIImage(named:"blast_button.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Blaster"
		}
		
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
