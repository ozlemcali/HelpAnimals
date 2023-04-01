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
   
    var selected = ""
    
    var selectedAnimalName = ""
   var userImage = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        animalCommentlabel.text = selectedAnimalName
        animalImageview.sd_setImage(with: URL(string: selected))
        
        
    }
    
    @IBAction func clickedBackButton(_ sender: Any) {
        performSegue(withIdentifier: "DetailVCtoHomePageVC", sender: nil)
    }
    
    func getImagesFromFirestore(){
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").addSnapshotListener { snapshot, error in
            
            if error != nil{
                print(error?.localizedDescription ?? "Error!")
            }else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                
                    
                    for document in snapshot!.documents {
                       
                        
                        if let imageUrls = document.get("imageUrl") as? String {
                            self.userImage.append(imageUrls)
                            self.animalImageview.sd_setImage(with: URL(string: self.userImage[0]))                        }
                    }
                
                   
                }
            }
        }
        
    }
    
    
    


}
