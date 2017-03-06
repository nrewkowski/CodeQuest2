//
//  playerCell.swift
//  Code Quest
//
//  Created by (You) Narukami on 9/20/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

class playerCell: gameCell {

    init() {
        super.init(image: UIImage(named:"player.png"))
        self.accessibilityLabel = "Player"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
