//
//  addFeedingPointViewController.swift
//  HelpAnimals
//
//  Created by ozlem on 9.03.2023.
//

import UIKit

class addFeedingPointViewController: UIViewController {

    @IBOutlet var addLocationButton: UIButton!
    @IBOutlet var addFeedingPointButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addFeedingPointButton.layer.cornerRadius = 25.0
        addFeedingPointButton.layer.borderWidth = 1
        addFeedingPointButton.layer.borderColor = UIColor.orange.cgColor
        
        addLocationButton.layer.cornerRadius = 17.0
        addLocationButton.layer.borderWidth = 1
        addLocationButton.layer.borderColor = UIColor.orange.cgColor
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
