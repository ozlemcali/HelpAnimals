

import UIKit
import Firebase

class addFeedingPointViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var addLocationButton: UIButton!
    @IBOutlet var addFeedingPointButton: UIButton!
    @IBOutlet var feedImageView: UIImageView!
    @IBOutlet var feedName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    
    
    // MARK: - Add Location
    @IBAction func clickedAddLocation(_ sender: Any) {
        
        
    }
    
    
    // MARK: - Add Feeding Point
    @IBAction func addFeedingPointClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = feedImageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).png")
            
            imageReference.putData(data) { metadata, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                } else {
                    
                    imageReference.downloadURL { url, error in
                        
                        if error == nil{
                            
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePosts = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email, "postName" : self.feedName.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Feed").addDocument(data: firestorePosts,completion: { error in
                                if error != nil{
                                    self.makeAlert(titleInput: "Error!", messageInput:error?.localizedDescription ?? "Error!")
                                }else{
                                    self.feedImageView.image = UIImage(named:"p3.png")
                                    self.feedName.text = ""
                                    self.performSegue(withIdentifier: "addFeedingPointVCtoFeedingPointVC", sender: nil)
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
