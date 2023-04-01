//
//  addAdoptAnimalViewController.swift
//  HelpAnimals
//
//  Created by ozlem on 9.03.2023.
//

import UIKit
import Firebase

class addAdoptAnimalViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tabBarController?.tabBar.isHidden = false
        
        addButton.layer.cornerRadius = 25.0
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.orange.cgColor
        imageView.isUserInteractionEnabled = true
        
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
        
    }
    
    @objc func choseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true,completion: nil)
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
        
    }
    
    
    @IBAction func addAdoptAnimalClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).png")
            
            imageReference.putData(data) { metadata, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                } else {
                    imageReference.downloadURL{ (url, error) in
                        if error == nil{
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePosts = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email, "postComment" : self.commentText.text!,"postedName" : self.nameText.text!,"postedAge" : self.ageText.text, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePosts,completion: { error in
                                if error != nil{
                                    self.makeAlert(titleInput: "Error!", messageInput:error?.localizedDescription ?? "Error!")
                                }else{
                                    self.imageView.image = UIImage(named:"p3.png")
                                    self.ageText.text = ""
                                    self.nameText.text = ""
                                    self.commentText.text = ""
                                    //self.tabBarController?.selectedIndex = 0
                                    self.performSegue(withIdentifier: "adoptAnimaltoHomePageVC", sender: nil)   
                                   
                                }
                            })
                            
                        }
                        
                    }
                    
                }
            }
            
                }
        
    }
    
    
    
    func makeAlert(titleInput : String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    
        
    }
    
}
