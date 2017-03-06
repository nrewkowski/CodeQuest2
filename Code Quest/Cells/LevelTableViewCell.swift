//
//  LevelTableViewCell.swift
//  Code Quest
//
//  Created by OSX on 9/21/16.
//  Copyright © 2016 Spookle. All rights reserved.
//

import UIKit

///Prototype cell for level selector
class LevelTableViewCell: UITableViewCell {

    //@IBOutlet weak var levelLabel: UIView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
