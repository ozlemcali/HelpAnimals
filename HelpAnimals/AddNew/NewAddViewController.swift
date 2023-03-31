//
//  NewAddViewController.swift
//  HelpAnimals
//
//  Created by ozlem on 9.03.2023.
//

import UIKit

class NewAddViewController: UIViewController {
    
    @IBOutlet var addFeedingPointButton: UIButton!
    
    @IBOutlet var addAdoptAnimalButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAdoptAnimalButton.layer.cornerRadius = 25.0
        addAdoptAnimalButton.layer.borderWidth = 1
       addAdoptAnimalButton.layer.borderColor = UIColor.orange.cgColor
        
        
        addFeedingPointButton.layer.cornerRadius = 25.0
        addFeedingPointButton.layer.borderWidth = 1
        addFeedingPointButton.layer.borderColor = UIColor.orange.cgColor
        
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addFeedingPointClicked(_ sender: Any) {
        
       
        performSegue(withIdentifier: "addFeedingPointVC", sender: nil)
    }
    
    @IBAction func addAdoptAnimalClicked(_ sender: Any) {
        performSegue(withIdentifier: "addAdoptAnimalVC", sender: nil)
       
        
    }
}
