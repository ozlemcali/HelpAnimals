//
//  HomePageViewController.swift
//  HelpAnimals
//
//  Created by ozlem on 9.03.2023.
//

import UIKit
import Firebase
import SDWebImage

class HomePageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
 
    @IBOutlet var tableView: UITableView!
    
    var userName = [String]()
    var userImage = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
       
        self.navigationItem.title = "Sahiplen!"
        tableView.dataSource = self
        tableView.delegate = self
        getDataFromFirestore()
       
        
    }
    
    func getDataFromFirestore(){
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").addSnapshotListener { snapshot, error in
            
            if error != nil{
                print(error?.localizedDescription ?? "Error!")
            }else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userName.removeAll(keepingCapacity: false)
                    self.userImage.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        if let animalNames = document.get("postedName") as? String {
                            self.userName.append(animalNames)
                        }
                        
                        if let imageUrls = document.get("imageUrl") as? String {
                            self.userImage.append(imageUrls)
                        }
                    }
                
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userName.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AnimalsTableViewCell
        cell.animalNameLabel.text = userName[indexPath.row]
        
      cell .animalImageView.sd_setImage(with: URL(string: self.userImage[indexPath.row]))
        return cell
    }
}
