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
	case ERASE1 = 6
	case ERASEALL = 7
	case QUEUESOUND = 8
	case LOOPCOMMAND = 5
	case HELP = 9
}

class Input: UIButton {
	
	///(To be) enum describing what type of command this button corresponds to 
	var type: ButtonType
	
	
	init(type: ButtonType, frame: CGRect) {
		self.type = type
		
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
		switch type {
		case ButtonType.LEFT:
			self.setImage(UIImage(named:"left.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Left"
			//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.RIGHT:
			self.setImage(UIImage(named:"right.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Right"
			//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.UP:
			self.setImage(UIImage(named:"up.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Up"
			//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.DOWN:
			self.setImage(UIImage(named:"down.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Down"
			//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.ERASE1:
			self.setImage(UIImage(named:"erase1.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Erase last command"
			//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.ERASEALL:
			self.setImage(UIImage(named:"eraseall.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Erase all commands"
			//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.QUEUESOUND:
			self.setImage(UIImage(named:"queuesound.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Hear the commands you have input"
			//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.BLAST:
			self.setImage(UIImage(named:"blast_button.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Blaster"
			//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.LOOPCOMMAND:
			self.setImage(UIImage(named:"loopsymbol.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Loop"
			//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.HELP:
			self.setImage(UIImage(named:"helpsymbol.png"), for: .normal)
			self.accessibilityLabel = "Help"
		}
		
		//self.isEnabled = false
	}
	
	init(type: ButtonType, frame: CGRect, isEnabled: Bool) {
		self.type = type
		
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
		switch type {
		case ButtonType.LEFT:
			self.setImage(UIImage(named:"left.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Left"
		//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.RIGHT:
			self.setImage(UIImage(named:"right.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Right"
		//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.UP:
			self.setImage(UIImage(named:"up.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Up"
		//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.DOWN:
			self.setImage(UIImage(named:"down.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Down"
		//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.ERASE1:
			self.setImage(UIImage(named:"erase1.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Erase last command"
		//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.ERASEALL:
			self.setImage(UIImage(named:"eraseall.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Erase all commands"
		//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.QUEUESOUND:
			self.setImage(UIImage(named:"queuesound.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Hear the commands you have input"
		//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.BLAST:
			self.setImage(UIImage(named:"blast_button.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Blaster"
		//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.LOOPCOMMAND:
			self.setImage(UIImage(named:"loopsymbol.png"), for: UIControlState.normal)
			self.accessibilityLabel = "Loop"
		//self.accessibilityTraits = UIAccessibilityTraitNone
		case ButtonType.HELP:
			self.setImage(UIImage(named:"helpsymbol.png"), for: .normal)
			self.accessibilityLabel = "Help"
		}
		
		self.isEnabled = isEnabled
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
