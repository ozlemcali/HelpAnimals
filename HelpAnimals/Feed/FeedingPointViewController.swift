//
//  FeedingPointViewController.swift
//  HelpAnimals
//
//  Created by ozlem on 9.03.2023.
//

import UIKit
import Firebase
import SDWebImage
class FeedingPointViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var userFeedNameArray = [String]()
    var userFeedImageArray = [String]()
    
    var chosenFeedName = ""
    var chosenFeedImage = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        self.title = "Beslenme Noktaları" //çalışmıyor.
        tableView.delegate = self
        tableView.dataSource = self
        getFeedDataFromFirestore()
    }
    
    
    func getFeedDataFromFirestore(){
        
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Feed").order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
                if error != nil {
                    print(error?.localizedDescription ?? "Error!")
                }else{
                    if snapshot?.isEmpty != true && snapshot != nil {
                        self.userFeedNameArray.removeAll(keepingCapacity: false)
                        self.userFeedImageArray.removeAll(keepingCapacity: false)
                        
                        for document in snapshot!.documents{
                            
                            if let feedNames = document.get("postName") as? String{
                                self.userFeedNameArray.append(feedNames)
                            }
                            if let imageUrls = document.get("imageUrl") as? String{
                                self.userFeedImageArray.append(imageUrls)
                            }
                            
                        }
                        self.tableView.reloadData()
                    }
                    
                }
            }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userFeedNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.feedImageView.sd_setImage(with: URL(string: self.userFeedImageArray[indexPath.row]))
        cell.feedLocationLabel.text = userFeedNameArray[indexPath.row]
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenFeedName = userFeedNameArray[indexPath.row]
        chosenFeedImage = userFeedImageArray[indexPath.row]
        performSegue(withIdentifier: "FeedingPointToDetailFeedVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "FeedingPointToDetailFeedVC" {
                let destinationVC = segue.destination as! DetailFeedViewController
                destinationVC.selectedFeedName = chosenFeedName
                destinationVC.selectedFeedImage = chosenFeedImage
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFeedDataFromFirestore()
    }
    
}
