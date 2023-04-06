//
//  DetailFeedViewController.swift
//  HelpAnimals
//
//  Created by ozlem on 2.04.2023.
//

import UIKit
import SDWebImage
import CoreData
import MapKit

class DetailFeedViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet var detailFeedName: UILabel!
    @IBOutlet var detailFeedImageView: UIImageView!
    @IBOutlet var detailMapView: MKMapView!
    
    
    var selectedFeedImage = ""
    var selectedFeedName = ""
    var selectedTitleID : UUID?
    
    
    var locationManager = CLLocationManager()
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false

        detailFeedName.text = selectedFeedName
        detailFeedImageView.sd_setImage(with: URL(string: selectedFeedImage))
        
        detailMapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        getLocation()
        
        
    }
    
    func getLocation(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        let idString = selectedTitleID!.uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    
                    if let latitude = result.value(forKey: "latitude") as? Double {
                        annotationLatitude = latitude
                        
                        
                        if let longitude = result.value(forKey: "longitude") as? Double {
                            annotationLongitude = longitude
                            
                            let annotation = MKPointAnnotation()
                            
                            
                            let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
                            annotation.coordinate = coordinate
                            
                            detailMapView.addAnnotation(annotation)
                            locationManager.startUpdatingLocation()
                            
                            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            let region = MKCoordinateRegion(center: coordinate, span: span)
                            detailMapView.setRegion(region, animated: true)
                            
                            
                        }
                        
                    }
                }
            }
        } catch {
            print("error")
        }
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "myAnnotation"
        var pinView = detailMapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.black
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        return pinView
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if detailFeedName.text != "" {
            
            let requestLocation = CLLocation(latitude: annotationLatitude, longitude: annotationLongitude)
            
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                //closure
                
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        
                        let newPlacemark = MKPlacemark(placemark: placemark[0])
                        let item = MKMapItem(placemark: newPlacemark)
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                        
                    }
                }
            }
            
            
        }
        
        
    }
    
    
}


