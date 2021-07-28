//
//  MapViewController.swift
//  LookyLoos
//
//  Created by Joshua Hoyle on 6/3/21.
//


import UIKit
import CoreLocation
import Firebase
import FirebaseUI
import MapKit


class MapViewController: UIViewController {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    //MARK: - Properties
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    var resultSearchController:UISearchController? = nil
    //var docRef: DocumentReference!
    var ref: DocumentReference? = nil
    var uid = Auth.auth().currentUser?.uid ?? ""
    let now = Date()
    let hourAgo = Date().addingTimeInterval(-3600)
    
    
    
    
    //MARK: - Lifecycle
    
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.showUserInfo(user: user)
            } else {
                self.showLoginVC()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let locationSearchTable = storyboard!.instantiateViewController(identifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Where are we going?"
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        displayPinsFromDB()
        locationManager.stopUpdatingLocation()
        
    }
    
    //MARK: - Actions
    
    @IBAction func centerButtonTapped(_ sender: Any) {
        locationManager.requestLocation()
         }
    
    @IBAction func ambulanceButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "What's going on?", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Type what's going on here..."
        }
        
        let doneAction = UIAlertAction(title: "Add Info", style: .default) { (_) in
            let eventText = alertController.textFields?.first?.text ?? ""
            
            self.locationManager.requestLocation()
            let latitude = self.locationManager.location?.coordinate.latitude ?? 0
            let longitude = self.locationManager.location?.coordinate.longitude ?? 0
            print(latitude)
            print(longitude)
            
            self.addAmbulanceAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude) , eventText: eventText)
            let eventTitle = "Ambulance"
            let eventSubtitle = "\(self.uid): \(eventText)"
            self.savePinToDB(eventTitle: eventTitle, eventSubtitle: eventSubtitle, latitude: latitude, longitude: longitude)
            
            print(eventText)
            //print(dataToSave)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
            }
    
    @IBAction func firetruckButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "What's going on?", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Type what's going on here..."
        }
        
        let doneAction = UIAlertAction(title: "Add Info", style: .default) { (_) in
            let eventText = alertController.textFields?.first?.text ?? ""
            
            self.locationManager.requestLocation()
            let latitude = self.locationManager.location?.coordinate.latitude ?? 0
            let longitude = self.locationManager.location?.coordinate.longitude ?? 0
            print(latitude)
            print(longitude)
            let eventTitle = "Fire"
            let eventSubtitle = "\(self.uid): \(eventText)"
            self.addFireAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude) , eventText: eventText)
            self.savePinToDB(eventTitle: eventTitle, eventSubtitle: eventSubtitle, latitude: latitude, longitude: longitude)
            
            print(eventText)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
            
    @IBAction func policeButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "What's going on?", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Type what's going on here..."
        }
        
        let doneAction = UIAlertAction(title: "Add Info", style: .default) { (_) in
            let eventText = alertController.textFields?.first?.text ?? ""
            
            self.locationManager.requestLocation()
            let latitude = self.locationManager.location?.coordinate.latitude ?? 0
            let longitude = self.locationManager.location?.coordinate.longitude ?? 0
            print(latitude)
            print(longitude)
            let eventTitle = "Fire"
            let eventSubtitle = "\(self.uid): \(eventText)"
            self.addPoliceAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude) , eventText: eventText)
            self.savePinToDB(eventTitle: eventTitle, eventSubtitle: eventSubtitle, latitude: latitude, longitude: longitude)
            print(eventText)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Functions
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
    }
    /*
    func reportAC(reportAnnotation: String, reportText: String) {
        let alertController = UIAlertController(title: "Report", message:
                                                    "Please provide additional information.", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Additional information here..."
        }
        let doneAction = UIAlertAction(title: "Report", style: .default) { (_) in
            let reportText = alertController.textFields?.first?.text ?? ""
            self.saveReportToDB(reportAnnotation: reportAnnotation, reportText: reportText)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    */
    func showUserInfo(user: User) {
    }
    
    func showLoginVC() {
        let authUI = FUIAuth.defaultAuthUI()
        let providers = [FUIEmailAuth()]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    func addAmbulanceAnnotation(coordinate: CLLocationCoordinate2D , eventText: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Ambulance"
        annotation.subtitle = eventText
        mapView.addAnnotation(annotation)
    }
    
    func addFireAnnotation(coordinate: CLLocationCoordinate2D , eventText: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Fire"
        annotation.subtitle = eventText
        mapView.addAnnotation(annotation)
    }
    
    func addPoliceAnnotation(coordinate: CLLocationCoordinate2D , eventText: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Police"
        annotation.subtitle = eventText
        mapView.addAnnotation(annotation)
    }
    
    func savePinToDB(eventTitle: String, eventSubtitle: String, latitude: Double, longitude: Double) {
        let newPinRef = db.collection("pins").document()
        newPinRef.setData([
            "eventTitle": eventTitle,
            "eventSubtitle": eventSubtitle,
            "latitude": latitude,
            "longitude": longitude,
            "lastupdated": FieldValue.serverTimestamp()
        ])
        
    }
    
    func saveReportToDB(reportAnnotation: String, reportText: String) {
        let newReportRef = db.collection("reports").document(uid)
        newReportRef.setData([
            "reportAnnotation": reportAnnotation,
            "reportText": reportText,
            "lastUpdated": FieldValue.serverTimestamp()
        ])
    }
    
    func displayPinsFromDB() {
        db.collection("pins").addSnapshotListener { QuerySnapshot, Error in
            guard let documents = QuerySnapshot?.documents else {
                print("No documents")
                return
            }
            let annotation = documents.map { QueryDocumentSnapshot -> Pin in
                let data = QueryDocumentSnapshot.data()
                let latitude = data["latitude"] as? Double ?? 0.0
                let longitude = data["longitude"] as? Double ?? 0.0
                let eventTitle = data["eventTitle"] as? String ?? ""
                let eventSubtitle = data["eventSubtitle"] as? String ?? ""
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.displayPins(coordinate: coordinate, eventSubtitle: eventSubtitle, eventTitle: eventTitle)
                
                return Pin(latitude: latitude, longitude: longitude, eventTitle: eventTitle, eventSubtitle: eventSubtitle)
            }
            print(annotation)
        }
    }
    
    func displayPins(coordinate: CLLocationCoordinate2D, eventSubtitle: String, eventTitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = eventTitle
        annotation.subtitle = eventSubtitle
        mapView.addAnnotation(annotation)
    }
}//end of class
//MARK: - Extension

extension MapViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        guard error == nil else {
            return
        }
        if error != nil {
            return
        }
    }
    
    
}//end of extension
//Alert controller being triggered on start of app.  Need to figure out how to get it to get called with right callout accessory button.
extension MapViewController: MKMapViewDelegate {
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let alertController = UIAlertController(title: "Report", message:
                                                        "Please provide additional information.", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "Additional information here..."

            let doneAction = UIAlertAction(title: "Report", style: .default) { (_) in
                guard let reportText = alertController.textFields?.first?.text else {return}
                let reportAnnotation = view.annotation?.subtitle
                self.saveReportToDB(reportAnnotation: ((reportAnnotation ?? "") ?? ""), reportText: reportText)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(doneAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
}
extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            print(center)
            mapView.setRegion(region, animated: true)
        }
        
        if locations.first != nil {
            print("location:: (location)")
        }
        
    }
    
}

