//
//  LocationViewController.swift
//  HelpAnimals
//
//  Created by ozlem on 9.03.2023.
//

import UIKit
import MapKit
import CoreData

class LocationViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    
    var selectedTitleID : UUID?
    var feedVC = FeedingPointViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
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
    
    
        let idString = feedVC.idArray
        //let idString = selectedTitleID?.uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString ?? "error")
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
                            
                            mapView.addAnnotation(annotation)
                            locationManager.startUpdatingLocation()
                            
                            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            let region = MKCoordinateRegion(center: coordinate, span: span)
                            mapView.setRegion(region, animated: true)
                            
                            
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
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
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
}
