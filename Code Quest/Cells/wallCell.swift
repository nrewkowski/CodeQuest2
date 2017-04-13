//
//  wallCell.swift
//  Code Quest
//
//  Created by (You) Narukami on 9/20/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

///A wall cell, which the player cannot cross
class wallCell: gameCell {
	var row:Int = -1
	var column:Int = -1
    init() {
        super.init(image: UIImage(named:"wall.png"))
        self.accessibilityLabel = "Wall"
		//self.accessibilityTraits = UIAccessibilityTraitNone
    }
	
	init(row:Int, column:Int) {
		self.row=row
		self.column=column
		
		super.init(image: UIImage(named:"wall.png"))
		self.accessibilityLabel = "Unbreakable wall, row"+String(self.row)+", column "+String(self.column)
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
