//
//  SettingsViewController.swift
//  HelpAnimals
//
//  Created by ozlem on 9.03.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet var emailLabel: UITextField!
    @IBOutlet var nameLabel: UITextField!
    
    @IBOutlet var addLogoutButton: UIButton!
    var user : SignInViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addLogoutButton.layer.cornerRadius = 25.0
        addLogoutButton.layer.borderWidth = 1
        addLogoutButton.layer.borderColor = UIColor.orange.cgColor
    
        emailLabel.text = user?.emailText.text
    }
    

    @IBAction func logoutClicked(_ sender: Any) {
        do{
           try Auth.auth().signOut()
            self.performSegue(withIdentifier: "settingsToHomePageVC", sender: nil)
            
        }catch{
            print("Error!")
        }
    }
    

}
