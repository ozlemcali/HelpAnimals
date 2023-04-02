//
//  DetailViewController.swift
//  HelpAnimals
//
//  Created by ozlem on 9.03.2023.
//

import UIKit
import Firebase
import SDWebImage

class DetailViewController: UIViewController {

    @IBOutlet var userConnectEmaillabel: UILabel!
    @IBOutlet var animalCommentlabel: UILabel!
    @IBOutlet var animalAgelabel: UILabel!
    @IBOutlet var animalImageview: UIImageView!
   
    var selectedAnimalImage = ""
    var selectedAnimalName = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
       
        animalCommentlabel.text = selectedAnimalName
        animalImageview.sd_setImage(with: URL(string: selectedAnimalImage))
        
        
    }
    
    @IBAction func clickedBackButton(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        performSegue(withIdentifier: "DetailVCtoHomePageVC", sender: nil)
       
      
    }
    


}
