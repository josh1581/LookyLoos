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
    var ref: DocumentReference? = nil
    var userUID = ""
    var blocked: [String] = []
    var pottyMouthWords = ["spic", "spics", "beaner", "beaners", "fag", "fags", "faggot", "faggots", "nigger", "niggers", "kike", "kikes", "gooks", "gooks", "dyke", "dykes", "homo", "homos"]
    
    
    //MARK: - Lifecycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        group.enter()
        
        firebaseLogin()
        guard let uid = Auth.auth().currentUser?.uid else
        {return}
        self.userUID = uid
        group.leave()
        
        group.enter()
        addBlockedDoc()
        fetchBlockedArray {[weak self] blockedArray in
            self?.blocked = blockedArray
            self?.loadAndPublishPins()
        }
        group.leave()
     
    }
    
    //MARK: - Actions
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        logout()
    }
    
    
    @IBAction func centerButtonTapped(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    @IBAction func ambulanceButtonTapped(_ sender: Any) {
        let eventType = "Ambulance"
        eventAC(eventType: eventType)
    }
    
    
    @IBAction func firetruckButtonTapped(_ sender: Any) {
        let eventType = "Fire"
        eventAC(eventType: eventType)
    }
    
    @IBAction func policeButtonTapped(_ sender: Any) {
        let eventType = "Police"
        eventAC(eventType: eventType)
    }
    
    //MARK: - Functions
    
    func addAnnotation(coordinate: CLLocationCoordinate2D, evenTitle: String, eventSubtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = evenTitle
        annotation.subtitle = eventSubtitle
        mapView.addAnnotation(annotation)
    }
    
    func addBlockedDoc() {
        let docRef = db.collection("blocked").document(userUID)
        docRef.getDocument { document, error in
            if let document = document, document.exists == false {
                let newBlockedRef = self.db.collection("blocked").document(self.userUID)
                newBlockedRef.setData([
                    "blockedUsers" : ["initialValue"]
                ])
            } else {
                return
            }
        }
    }
    
    func blockedAC() {
        let alertController = UIAlertController(title: "User has been blocked", message: nil, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func blockUser(userToBlock: String) {
        blocked.append(userToBlock)
        let newBlockedRef = db.collection("blocked").document(userUID)
        newBlockedRef.updateData([
            "blockedUsers": FieldValue.arrayUnion([userToBlock])
        ])
        blockedAC()
    }
    
    func displayPin(coordinate: CLLocationCoordinate2D, eventSubtitle: String, eventTitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = eventTitle
        annotation.subtitle = eventSubtitle
        print("Blocked Array: \(blocked)")
        if blocked.contains(eventSubtitle) == true {
            print(blocked.contains)
        } else {
            mapView.addAnnotation(annotation)
        }
    }
    
    
    func fetchAndDisplayPinsFromDB() {
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
                self.displayPin(coordinate: coordinate, eventSubtitle: eventSubtitle, eventTitle: eventTitle)
                return Pin(latitude: latitude, longitude: longitude, eventTitle: eventTitle, eventSubtitle: eventSubtitle)
            }
            print(annotation)
        }
    }
    func eula() {
        let alertController = UIAlertController(title: "End User License Agreement (EULA)", message: "LookyLoos has a zero tolerance policy for all hate speech and offensive language.  By using using the LookyLoos app you agree to abide by these conditions.  Any violations can result in the removal of the offending content and the offending user from the platform." , preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func eventAC(eventType: String) {
        let alertController = UIAlertController(title: "What's going on?", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Type what's going on here..."
        }
        let doneAction = UIAlertAction(title: "Add Info", style: .default) { (_) in
            let eventText = alertController.textFields?.first?.text ?? ""
            self.locationManager.requestLocation()
            let latitude = self.locationManager.location?.coordinate.latitude ?? 0
            let longitude = self.locationManager.location?.coordinate.longitude ?? 0
            let pottyMouthWordsPresent = self.pottyMouthWords.contains(where: eventText.contains)
            if pottyMouthWordsPresent == true {
                self.pottyMouthAC()
            }else{
                let eventTitle = "\(eventType): \(eventText)"
                self.addAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), evenTitle: eventTitle, eventSubtitle: self.userUID)
                PinsController.savePinToDB(eventTitle: eventTitle, eventSubtitle: self.userUID, latitude: latitude, longitude: longitude)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func fetchBlockedArray(completion: @escaping (_ result: [String]) -> Void) {
        
        db.collection("blocked").document(userUID).getDocument { document, error in
            if let document = document {
                let blockedArray = document["blockedUsers"] as? [String] ?? [""]
                completion(blockedArray)
            }
        }
    }
    
    func firebaseLogin() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                
                self.showUserInfo(user: user)
                
            } else {
                let group = DispatchGroup()
                group.enter()
                self.showLoginVC()
                
                group.leave()
            }
        }
    }
    
    func logout() {
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        navigationController?.popToRootViewController(animated: true)
    }
    
    func pottyMouthAC() {
        let alertController = UIAlertController(title: "Offensive Language", message:
                                                    "Please rephrase your event information and try again", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .default) { (_) in
            return
        }
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadAndPublishPins() {
        let group = DispatchGroup()
        group.enter()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
        group.leave()
        group.notify(queue: DispatchQueue.global()) {
            self.fetchAndDisplayPinsFromDB()
        }
        eula()
    }
    
    
    /*
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
    
    func saveReportToDB(reportTitle: String, reportSubtitle: String, reportText: String) {
        let newReportRef = db.collection("reports").document(userUID)
        newReportRef.setData([
            "reportTitle": reportTitle,
            "reportSubtitle": reportSubtitle,
            "reportText": reportText,
            "lastUpdated": FieldValue.serverTimestamp()
        ])
    }
  */
    func showLoginVC() {
        let authUI = FUIAuth.defaultAuthUI()
        let providers = [FUIEmailAuth()]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    func showUserInfo(user: User) {
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
                    let reportTitle = view.annotation?.title
                    let reportSubtitle = view.annotation?.subtitle
                    
                    PinsController.saveReportToDB(reportTitle: (reportTitle ?? "") ?? "", reportSubtitle: (reportSubtitle ?? "") ?? "", reportText: reportText)
                }
                let blockAction = UIAlertAction(title: "Block", style: .default) { (_) in
                    guard let userToBlock  = view.annotation?.subtitle else
                    {return}
                    self.blockUser(userToBlock: userToBlock ?? "")
                    self.viewDidLoad()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(doneAction)
                alertController.addAction(blockAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
} //end of extension

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
            //print("location: \(location)")
        }
    }
}//end of extension

