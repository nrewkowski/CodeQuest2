//
//  gameCell.swift
//  Code Quest
//
//  Created by OSX on 9/20/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

///Superclass for  cells that render on the grid 
class gameCell: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(image: UIImage?) {
        super.init(image: image)
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraitImage
        self.accessibilityLabel = "Empty"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
