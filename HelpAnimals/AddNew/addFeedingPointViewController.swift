//
//  addFeedingPointViewController.swift
//  HelpAnimals
//
//  Created by ozlem on 9.03.2023.
//

import UIKit
import Firebase

class addFeedingPointViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var addLocationButton: UIButton!
    @IBOutlet var addFeedingPointButton: UIButton!
    
    @IBOutlet var feedImageView: UIImageView!
    
    @IBOutlet var feedName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = false
        
        addFeedingPointButton.layer.cornerRadius = 25.0
        addFeedingPointButton.layer.borderWidth = 1
        addFeedingPointButton.layer.borderColor = UIColor.orange.cgColor
        
        addLocationButton.layer.cornerRadius = 17.0
        addLocationButton.layer.borderWidth = 1
        addLocationButton.layer.borderColor = UIColor.orange.cgColor
        
        feedImageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choseImage))
        feedImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    @objc func choseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true,completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        feedImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
        
    }
    
    
    
    

    @IBAction func clickedAddLocation(_ sender: Any) {
        
        
    }
    
    @IBAction func addFeedingPointClicked(_ sender: Any) {
        
        
        
    }
    
    
    
    
    func makeAlert(titleInput : String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    
        
    }
}
