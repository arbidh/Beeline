//
//  TournamentCell.swift
//  BeelineCodingChallenge
//
//  Created by Arbi on 1/18/18.
//  Copyright © 2018 org.beelinecoding. All rights reserved.
//

import UIKit

class TournamentCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var date: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
