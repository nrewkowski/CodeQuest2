//
//  goalCell.swift
//  Code Quest
//
//  Created by (You) Narukami on 9/21/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

///Cell that contains the goal
class goalCell: gameCell {

    init() {
        super.init(image: UIImage(named:"ship_grid.png"))
        self.accessibilityLabel = "Goal"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
