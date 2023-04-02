//
//  FeedTableViewCell.swift
//  HelpAnimals
//
//  Created by ozlem on 2.04.2023.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet var feedDistanceLabel: UILabel!
    @IBOutlet var feedLocationLabel: UILabel!
    @IBOutlet var feedImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
