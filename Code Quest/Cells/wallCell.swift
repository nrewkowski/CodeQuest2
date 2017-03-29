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

    init() {
        super.init(image: UIImage(named:"wall.png"))
        self.accessibilityLabel = "Wall"
		self.accessibilityTraits = UIAccessibilityTraitNone
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
