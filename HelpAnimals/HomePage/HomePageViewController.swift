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
    
    var userNameArray = [String]()
    var userImageArray = [String]()
    
    
    var chosenAnimalName = ""
    var chosenAnimalImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sahiplen!"
        tableView.dataSource = self
        tableView.delegate = self
        getDataFromFirestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataFromFirestore()
    }
    
    
    func getDataFromFirestore(){
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true)
            
            
            .addSnapshotListener { snapshot, error in
            
            if error != nil{
                print(error?.localizedDescription ?? "Error!")
            }else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userNameArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        if let animalNames = document.get("postedName") as? String {
                            self.userNameArray.append(animalNames)
                        }
                        
                        if let imageUrls = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrls)
                        }
                    }
                
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNameArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AnimalsTableViewCell
        cell.animalNameLabel.text = userNameArray[indexPath.row]
        
        cell.animalImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chosenAnimalName = userNameArray[indexPath.row]
        chosenAnimalImage = userImageArray[indexPath.row]
        performSegue(withIdentifier: "HomePageToDetailVC", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "HomePageToDetailVC" {
                let destinationVC = segue.destination as! DetailViewController
                destinationVC.selectedAnimalName = chosenAnimalName
                destinationVC.selectedAnimalImage = chosenAnimalImage
            }
        }
    
   
}
