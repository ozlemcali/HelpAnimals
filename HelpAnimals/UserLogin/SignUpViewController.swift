//
//  SignUpViewController.swift
//  HelpAnimals
//
//  Created by ozlem on 8.03.2023.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
                   Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                       
                       if error != nil {
                           self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                       } else {
                           self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                           
                       }
                   }
               
               } else {
                   makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
               }
        
    }
    
    func makeAlert(titleInput:String, messageInput:String) {
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
        }
}
