

import UIKit
import Firebase
import FirebaseFirestore
import MapKit
import CoreLocation
import CoreData

class addFeedingPointViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MKMapViewDelegate,CLLocationManagerDelegate {
    
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addFeedingPointButton: UIButton!
    @IBOutlet var feedImageView: UIImageView!
    @IBOutlet var feedName: UITextField!
    
    var locationManager = CLLocationManager()
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        
        addFeedingPointButton.layer.cornerRadius = 25.0
        addFeedingPointButton.layer.borderWidth = 1
        addFeedingPointButton.layer.borderColor = UIColor.orange.cgColor
        
        feedImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        feedImageView.addGestureRecognizer(gestureRecognizer)
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureRecognizerLocation = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizerLocation:)))
        gestureRecognizerLocation.minimumPressDuration = 2
        mapView.addGestureRecognizer(gestureRecognizerLocation)
    }
    
    // MARK: - Get Images
    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true,completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        feedImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
        
    }
    
    //MARK: - Get Locations
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if feedName.text == ""{
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @objc func chooseLocation(gestureRecognizerLocation : UILongPressGestureRecognizer){
        if gestureRecognizerLocation.state == .began{
            
            let touchedPoint = gestureRecognizerLocation.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            chosenLatitude = touchedCoordinates.latitude
            chosenLongitude = touchedCoordinates.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = feedName.text
            annotation.subtitle = "Feeding Point"
            self.mapView.addAnnotation(annotation)
        }
        
    }
    
    // MARK: - Add Feeding Point
    @IBAction func addFeedingPointClicked(_ sender: Any) {
        
        //Choose Images
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
                                    self.performSegue(withIdentifier: "addFeedingPointToFeedingPointVC", sender: nil)
                                }
                            })
                            
                        }
                        
                    }
                    
                }
            }
            
        }
        
        //Choose Location
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        newPlace.setValue(chosenLatitude, forKey: "latitude")
        newPlace.setValue(chosenLongitude, forKey: "longitude")
        newPlace.setValue(UUID(), forKey: "id")
        
        
        do{
            try context.save()
            print("success")
        }catch{
            print(error.localizedDescription)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newPlace"), object: nil)
        navigationController?.popViewController(animated: true)
        
        
    }
    
    
    
    
    
    
    // MARK: - ALert Messages
    
    func makeAlert(titleInput : String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
        
        
    }
    
}
