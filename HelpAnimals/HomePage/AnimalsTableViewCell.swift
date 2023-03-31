//
//  AnimalsTableViewCell.swift
//  HelpAnimals
//
//  Created by ozlem on 31.03.2023.
//

import UIKit

class AnimalsTableViewCell: UITableViewCell {

    @IBOutlet var locationLabel: UILabel!
  
    @IBOutlet var animalImageView: UIImageView!
    @IBOutlet var animalNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
