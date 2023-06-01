//
//  ViewController.swift
//  HelpAnimals
//
//  Created by ozlem on 7.03.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        button.layer.cornerRadius = 25.0
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.orange.cgColor
       
    }

    @IBAction func buttonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignInVC", sender: nil)
    }
    
}

