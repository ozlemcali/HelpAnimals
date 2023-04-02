//
//  DetailFeedViewController.swift
//  HelpAnimals
//
//  Created by ozlem on 2.04.2023.
//

import UIKit
import SDWebImage

class DetailFeedViewController: UIViewController {

    @IBOutlet var detailFeedLocation: UILabel!
    @IBOutlet var detailFeedName: UILabel!
    @IBOutlet var detailFeedImageView: UIImageView!
    
    
     var selectedFeedImage = ""
     var selectedFeedName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        
        detailFeedName.text = selectedFeedName
        detailFeedImageView.sd_setImage(with: URL(string: selectedFeedImage))

    }
    

    @IBAction func backButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "DetailFeedVCToFeedingPointVC", sender: nil)
    }
    
}
